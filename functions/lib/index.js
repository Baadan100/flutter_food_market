"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createPaymentIntent = void 0;
const functions = require("firebase-functions");
const stripe_1 = require("stripe");
const stripe = new stripe_1.default(functions.config().stripe?.secret, {
    apiVersion: "2024-06-20",
});
exports.createPaymentIntent = functions.https.onCall(async (data, _ctx) => {
    const amount = Number(data?.amount ?? 0);
    const currency = String(data?.currency ?? "sar");
    if (!amount || amount < 1) {
        throw new functions.https.HttpsError("invalid-argument", "amount is required");
    }
    const intent = await stripe.paymentIntents.create({
        amount,
        currency,
        automatic_payment_methods: { enabled: true },
    });
    return { clientSecret: intent.client_secret };
});
//# sourceMappingURL=index.js.map