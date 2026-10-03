// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylebox/generated/l10n.dart';

import '../../data/chatbot/food_bot_rules.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({
    super.key,
    this.initialMessage,
    this.initialDisplayMessage,
  });

  static const String routeName = '/aiChat';

  final String? initialMessage;
  final String? initialDisplayMessage;

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _RateLimitException implements Exception {
  const _RateLimitException(this.retryAfterSeconds);

  final int retryAfterSeconds;

  @override
  String toString() => 'rate_limited:$retryAfterSeconds';
}

class _ChatMessage {
  const _ChatMessage({
    this.id,
    required this.text,
    this.rawText,
    required this.isUser,
    required this.ts,
  });

  final String? id;
  final String text;
  final String? rawText;
  final bool isUser;
  final DateTime ts;
}

class _AiChatViewState extends State<AiChatView> {
  static const String _proxyBaseUrl =
      'https://YOUR-WORKER.workers.dev';
  static const String _welcomeMessage =
      'أهلًا! أنا مساعد الستايل في StyleBox. اسألني عن الستايل بوكس، المقاسات، الحجز والاستلام، أو نصايح التنسيق.\n\nمثال: "إيه اللي جوه البوكس؟" أو "ألبس إيه مع جاكيت جينز؟" أو "إزاي أحجز؟"';

  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool _isSending = false;
  String? _lastUserMessageForRetry;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _fireSub;
  bool _didAutoSend = false;
  bool _didAutoFollowUp = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(text: _welcomeMessage, isUser: false, ts: DateTime.now()),
  ];

  CollectionReference<Map<String, dynamic>>? _messagesRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(user.uid)
        .collection('messages');
  }

  void _listenToFirestore() {
    _fireSub?.cancel();
    final ref = _messagesRef();
    if (ref == null) return;

    _fireSub = ref
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen(
          (snap) {
            final loaded = <_ChatMessage>[];
            for (final d in snap.docs) {
              final data = d.data();
              final text = (data['text'] ?? '').toString();
              final isUser = (data['isUser'] ?? false) == true;
              final createdAt = data['createdAt'];
              final clientTs = data['clientTs'];

              DateTime ts = DateTime.now();
              if (createdAt is Timestamp) {
                ts = createdAt.toDate();
              } else if (clientTs is Timestamp) {
                ts = clientTs.toDate();
              }

              if (text.trim().isEmpty) continue;
              loaded.add(
                _ChatMessage(id: d.id, text: text, isUser: isUser, ts: ts),
              );
            }

            if (!mounted) return;
            setState(() {
              final greeting = _messages.isNotEmpty ? _messages.first : null;
              _messages
                ..clear()
                ..add(
                  greeting ??
                      _ChatMessage(
                        text: _welcomeMessage,
                        isUser: false,
                        ts: DateTime.now(),
                      ),
                )
                ..addAll(loaded);
            });
          },
          onError: (error, stackTrace) {
            debugPrint('Firestore chat stream error: $error');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to load chat messages right now.'),
              ),
            );
          },
        );
  }

  @override
  void initState() {
    super.initState();
    _listenToFirestore();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msg = widget.initialMessage;
      if (_didAutoSend) return;
      if (msg == null || msg.trim().isEmpty) return;
      _didAutoSend = true;
      _controller.text = msg;
      _send(overrideVisibleText: widget.initialDisplayMessage);
    });
  }

  bool _looksIncompleteNutritionReply(String text) {
    final t = text.toLowerCase();
    if (t.trim().length < 140) return true;
    final has1 = t.contains('1)') || t.contains('1-') || t.contains('1.');
    final has2 = t.contains('2)') || t.contains('2-') || t.contains('2.');
    final has3 = t.contains('3)') || t.contains('3-') || t.contains('3.');
    final has4 = t.contains('4)') || t.contains('4-') || t.contains('4.');
    return !(has1 && has2 && has3 && has4);
  }

  Set<int> _presentSections(String text) {
    final t = text.toLowerCase();
    final out = <int>{};
    if (t.contains('1)') ||
        t.contains('1-') ||
        t.contains('\n1.') ||
        t.startsWith('1.')) {
      out.add(1);
    }
    if (t.contains('2)') ||
        t.contains('2-') ||
        t.contains('\n2.') ||
        t.startsWith('2.')) {
      out.add(2);
    }
    if (t.contains('3)') ||
        t.contains('3-') ||
        t.contains('\n3.') ||
        t.startsWith('3.')) {
      out.add(3);
    }
    if (t.contains('4)') ||
        t.contains('4-') ||
        t.contains('\n4.') ||
        t.startsWith('4.')) {
      out.add(4);
    }
    return out;
  }

  Future<String> _completeNutritionReplyIfNeeded({
    required String rawUserPrompt,
    required List<Map<String, String>> history,
    required String firstReply,
  }) async {
    var combined = firstReply.trim();
    if (combined.isEmpty) return combined;

    for (var attempt = 0; attempt < 2; attempt++) {
      final present = _presentSections(combined);
      final missing = <int>[
        1,
        2,
        3,
        4,
      ].where((s) => !present.contains(s)).toList();
      final tooShort = combined.trim().length < 140;
      if (!tooShort && missing.isEmpty) break;

      String followUp;
      if (tooShort && missing.length >= 3) {
        followUp =
            'أعد كتابة الإجابة كاملة في رسالة واحدة وبنفس التنظيم 1-4 وبأرقام تقريبية ونصايح عملية. لا تكتب عنوان فقط.';
      } else if (missing.isNotEmpty) {
        followUp =
            'كمّل الأقسام الناقصة فقط: ${missing.join(', ')}. '
            'اكتب كل قسم مرقّم وبأرقام تقريبية ونصايح عملية. لا تعيد الأقسام المكتوبة بالفعل.';
      } else {
        followUp =
            'كمّل الرد بنفس التنظيم في 4 أقسام (1-4) وبأرقام تقريبية ونصايح عملية. لو ناقص قسم أو أكثر، اكتبه الآن.';
      }

      final next = await _sendToProxyWithRetry(
        message: followUp,
        role: 'customer',
        history: [
          ...history,
          {'role': 'user', 'text': rawUserPrompt},
          {'role': 'model', 'text': combined},
        ],
      );

      final trimmed = next.trim();
      if (trimmed.isEmpty) break;

      if (tooShort && missing.length >= 3) {
        combined = trimmed;
      } else {
        combined = '$combined\n\n$trimmed';
      }
    }

    final presentAfter = _presentSections(combined);
    final missingAfter = <int>[
      1,
      2,
      3,
      4,
    ].where((s) => !presentAfter.contains(s)).toList();
    if (combined.trim().length < 140 || missingAfter.isNotEmpty) {
      final sections = <int, String>{};
      for (final s in [1, 2, 3, 4]) {
        try {
          String resp = await _sendToProxyWithRetry(
            message:
                'اكتب القسم $s فقط وبالعربي وبشكل مختصر وواضح. لا تكتب أي أقسام أخرى. استخدم نفس أسلوب التحليل الغذائي/الصحي.',
            role: 'customer',
            history: [
              ...history,
              {'role': 'user', 'text': rawUserPrompt},
            ],
          );
          var trimmed = resp.trim();

          if (trimmed.length < 40) {
            resp = await _sendToProxyWithRetry(
              message:
                  'اكتب القسم $s فقط في فقرة واحدة وبالعربي. ممنوع تكتب رقم أو عنوان بس. لازم تفاصيل وأرقام تقريبية/أمثلة حسب القسم. لا تكتب أي أقسام أخرى.',
              role: 'customer',
              history: [
                ...history,
                {'role': 'user', 'text': rawUserPrompt},
              ],
            );
            trimmed = resp.trim();
          }

          if (trimmed.trim().length >= 40) {
            sections[s] = trimmed;
          }
        } catch (_) {
          // skip this section
        }
      }

      if (sections.isNotEmpty) {
        final out = StringBuffer();
        for (final s in [1, 2, 3, 4]) {
          final t = sections[s];
          if (t == null || t.trim().isEmpty) continue;
          if (out.isNotEmpty) out.writeln('\n');
          out.writeln('$s) ${t.trim()}');
        }
        final built = out.toString().trim();
        if (built.isNotEmpty) return built;
      }

      return 'الرد رجع ناقص جدًا من خدمة التحليل. جرّب تاني (Retry) أو أعد إرسال الطلب.';
    }

    return combined.trim();
  }

  @override
  void dispose() {
    _fireSub?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _historyForProxy() {
    final items = <Map<String, String>>[];

    for (var i = 1; i < _messages.length; i++) {
      final m = _messages[i];
      final text = (m.rawText ?? m.text).trim();
      if (text.isEmpty) continue;
      items.add({'role': m.isUser ? 'user' : 'model', 'text': text});
    }

    const maxMessages = 10;
    if (items.length <= maxMessages) return items;
    return items.sublist(items.length - maxMessages);
  }

  Future<void> _retryAiFor(String userMessage) async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final history = _historyForProxy();
      final reply = await _sendToProxyWithRetry(
        message: userMessage,
        role: 'customer',
        history: history,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(text: reply, isUser: false, ts: DateTime.now()),
        );
        _isSending = false;
      });

      final ref = _messagesRef();
      if (ref != null) {
        await ref.add({
          'text': reply,
          'isUser': false,
          'createdAt': FieldValue.serverTimestamp(),
          'clientTs': Timestamp.fromDate(DateTime.now()),
        });
      }
    } on _RateLimitException catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'تم الوصول للحد (6/دقيقة). استنى ${e.retryAfterSeconds} ثانية وحاول تاني.',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String> _sendToProxyWithRetry({
    required String message,
    required String role,
    required List<Map<String, String>> history,
  }) async {
    const timeout = Duration(seconds: 45);

    try {
      return await _sendToProxy(
        message: message,
        role: role,
        history: history,
      ).timeout(timeout);
    } catch (_) {
      return await _sendToProxy(
        message: message,
        role: role,
        history: history,
      ).timeout(timeout);
    }
  }

  Future<String> _sendToProxy({
    required String message,
    required String role,
    required List<Map<String, String>> history,
  }) async {
    final uri = Uri.parse('$_proxyBaseUrl/chat');
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);

    try {
      final req = await client.postUrl(uri);
      req.headers.contentType = ContentType.json;
      req.write(
        jsonEncode({'message': message, 'role': role, 'history': history}),
      );

      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      if (resp.statusCode == 429) {
        try {
          final json = jsonDecode(body);
          final retry = json is Map ? json['retryAfterSeconds'] : null;
          final seconds = retry is num ? retry.round() : 60;
          throw _RateLimitException(seconds);
        } catch (_) {
          throw const _RateLimitException(60);
        }
      }
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw HttpException('proxy_error_${resp.statusCode}: $body', uri: uri);
      }

      final json = jsonDecode(body);
      final reply = json is Map ? json['reply'] : null;
      if (reply is String && reply.trim().isNotEmpty) return reply.trim();
      return 'مش قادر أرد دلوقتي. جرّب تاني.';
    } finally {
      client.close(force: true);
    }
  }

  Future<void> _send({String? overrideVisibleText}) async {
    final rawText = _controller.text.trim();
    final text = (overrideVisibleText ?? rawText).trim();
    if (text.isEmpty) return;
    if (_isSending) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          rawText: rawText,
          isUser: true,
          ts: DateTime.now(),
        ),
      );
      _controller.clear();
      _isSending = true;
    });

    _lastUserMessageForRetry = rawText;

    final ref = _messagesRef();
    if (ref != null) {
      await ref.add({
        'text': text,
        'rawText': rawText,
        'isUser': true,
        'createdAt': FieldValue.serverTimestamp(),
        'clientTs': Timestamp.fromDate(DateTime.now()),
      });
    }

    try {
      final history = _historyForProxy();
      final reply = await _sendToProxyWithRetry(
        message: rawText,
        role: 'customer',
        history: history,
      );

      String finalReply = reply;
      if (!_didAutoFollowUp && _looksIncompleteNutritionReply(reply)) {
        _didAutoFollowUp = true;
        try {
          finalReply = await _completeNutritionReplyIfNeeded(
            rawUserPrompt: rawText,
            history: history,
            firstReply: reply,
          );
        } catch (_) {
          // keep original reply
        }
      }

      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(text: finalReply, isUser: false, ts: DateTime.now()),
        );
        _isSending = false;
      });

      if (ref != null) {
        await ref.add({
          'text': finalReply,
          'isUser': false,
          'createdAt': FieldValue.serverTimestamp(),
          'clientTs': Timestamp.fromDate(DateTime.now()),
        });
      }
    } on _RateLimitException catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'تم الوصول للحد (6/دقيقة). استنى ${e.retryAfterSeconds} ثانية وحاول تاني.',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;

      final fallback = FoodBotRules.reply(text);
      setState(() {
        _messages.add(
          _ChatMessage(text: fallback, isUser: false, ts: DateTime.now()),
        );
        _isSending = false;
      });

      if (ref != null) {
        await ref.add({
          'text': fallback,
          'isUser': false,
          'createdAt': FieldValue.serverTimestamp(),
          'clientTs': Timestamp.fromDate(DateTime.now()),
          'isFallback': true,
        });
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: const Text('AI مش متاح دلوقتي. عايز تحاول تاني؟'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                final last = _lastUserMessageForRetry;
                if (last == null || last.trim().isEmpty) return;
                _retryAiFor(last);
              },
            ),
          ),
        );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _clearAllChat() async {
    if (_isSending) return;
    final locale = S.of(context)!;

    final shouldClear =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            final scheme = Theme.of(context).colorScheme;
            return AlertDialog(
              icon: Icon(Icons.delete_sweep_rounded, color: scheme.error),
              title: Text(locale.aiChatClearDialogTitle),
              content: Text(locale.aiChatClearDialogMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(locale.aiChatActionCancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(locale.aiChatActionClear),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldClear || !mounted) return;

    setState(() {
      _isSending = true;
    });

    try {
      final ref = _messagesRef();
      if (ref != null) {
        final snap = await ref.get();
        var batch = FirebaseFirestore.instance.batch();
        var ops = 0;

        for (final doc in snap.docs) {
          batch.delete(doc.reference);
          ops++;

          if (ops == 400) {
            await batch.commit();
            batch = FirebaseFirestore.instance.batch();
            ops = 0;
          }
        }

        if (ops > 0) {
          await batch.commit();
        }
      }

      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..add(
            _ChatMessage(
              text: _welcomeMessage,
              isUser: false,
              ts: DateTime.now(),
            ),
          );
        _lastUserMessageForRetry = null;
        _didAutoFollowUp = false;
        _isSending = false;
      });

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(locale.aiChatClearSuccess)));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(locale.aiChatClearFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = S.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(locale.aiChatTitle),
        actions: [
          IconButton(
            tooltip: locale.aiChatClearButton,
            onPressed: _isSending ? null : _clearAllChat,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final align = msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft;
                        final bg = msg.isUser
                            ? scheme.primaryContainer
                            : scheme.surfaceContainerHighest;
                        final fg = msg.isUser
                            ? scheme.onPrimaryContainer
                            : scheme.onSurface;
                        final borderColor = msg.isUser
                            ? scheme.primary.withOpacity(0.18)
                            : scheme.outlineVariant.withOpacity(0.35);

                        final time =
                            '${msg.ts.hour.toString().padLeft(2, '0')}:${msg.ts.minute.toString().padLeft(2, '0')}';

                        return Align(
                          alignment: align,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            constraints: const BoxConstraints(maxWidth: 340),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: fg, height: 1.25),
                                ),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    time,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: scheme.onSurfaceVariant
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (_isSending)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: scheme.outlineVariant.withOpacity(0.35),
                        ),
                      ),
                      child: const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: locale.aiChatInputHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _isSending ? null : _send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
