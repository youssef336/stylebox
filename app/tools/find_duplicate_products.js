// Scan Firestore `resturants` collection for duplicated embedded products.
// Usage:
// 1) Set `GOOGLE_APPLICATION_CREDENTIALS` to a service account JSON,
//    or pass `--serviceAccount=path/to/key.json`.
// 2) From the repo root: `node tools/find_duplicate_products.js`
// Output: prints duplicates and writes `tools/duplicate_products_report.json`.

const fs = require("fs");
const path = require("path");
const admin = require("firebase-admin");

function initApp() {
  const arg = process.argv.find((a) => a.startsWith("--serviceAccount="));
  if (arg) {
    const p = arg.split("=")[1];
    const key = require(path.resolve(p));
    admin.initializeApp({ credential: admin.credential.cert(key) });
    console.log("Initialized admin with provided service account.");
  } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    admin.initializeApp();
    console.log("Initialized admin using GOOGLE_APPLICATION_CREDENTIALS.");
  } else {
    console.error(
      "No service account provided. Set GOOGLE_APPLICATION_CREDENTIALS or pass --serviceAccount=...",
    );
    process.exit(1);
  }
}

async function run() {
  initApp();
  const db = admin.firestore();
  const restaurantsSnap = await db.collection("resturants").get();
  console.log(`Found ${restaurantsSnap.size} restaurants`);

  const duplicates = {
    byProductId: {},
    byRestaurantTitle: {},
  };

  for (const doc of restaurantsSnap.docs) {
    const restaurantId = doc.id;
    const data = doc.data() || {};
    const products = Array.isArray(data.products) ? data.products : [];
    for (let i = 0; i < products.length; i++) {
      const p = products[i] || {};
      const productId = (p.productId || p.docId || p.documentId || p.id || "")
        .toString()
        .trim();
      const title = (p.title || p.nameEn || "").toString().trim();

      if (productId) {
        if (!duplicates.byProductId[productId])
          duplicates.byProductId[productId] = [];
        duplicates.byProductId[productId].push({
          restaurantDocId: restaurantId,
          index: i,
          product: p,
        });
      }

      if (title) {
        const key = `${restaurantId}||${title}`;
        if (!duplicates.byRestaurantTitle[key])
          duplicates.byRestaurantTitle[key] = [];
        duplicates.byRestaurantTitle[key].push({
          restaurantDocId: restaurantId,
          index: i,
          product: p,
        });
      }
    }
  }

  // Filter only entries with more than one occurrence
  const dupByProductId = Object.entries(duplicates.byProductId)
    .filter(([k, v]) => v.length > 1)
    .map(([k, v]) => ({ productId: k, occurrences: v }));
  const dupByRestaurantTitle = Object.entries(duplicates.byRestaurantTitle)
    .filter(([k, v]) => v.length > 1)
    .map(([k, v]) => {
      const [restaurantId, title] = k.split("||");
      return { restaurantId, title, occurrences: v };
    });

  const report = { dupByProductId, dupByRestaurantTitle };
  const outPath = path.resolve(__dirname, "duplicate_products_report.json");
  fs.writeFileSync(outPath, JSON.stringify(report, null, 2));
  console.log(`Report written to ${outPath}`);

  console.log("\nSummary:");
  console.log(`- duplicate productId groups: ${dupByProductId.length}`);
  console.log(
    `- duplicate title-within-restaurant groups: ${dupByRestaurantTitle.length}`,
  );
  console.log("\nCheck tools/duplicate_products_report.json for details.");
  process.exit(0);
}

run().catch((err) => {
  console.error(err);
  process.exit(2);
});
