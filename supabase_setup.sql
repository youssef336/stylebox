-- StyleBox: storage bucket for product / store images.
-- Run once in Supabase -> SQL Editor.

insert into storage.buckets (id, name, public)
values ('product_images', 'product_images', true)
on conflict (id) do nothing;

-- The dashboard talks to Supabase with the anon key (no Supabase auth),
-- so the anon role needs upload / read / delete on this bucket only.
create policy "product_images upload"
  on storage.objects for insert to anon, authenticated
  with check (bucket_id = 'product_images');

create policy "product_images read"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'product_images');

create policy "product_images delete"
  on storage.objects for delete to anon, authenticated
  using (bucket_id = 'product_images');
