import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import Stripe from "stripe";

admin.initializeApp();

const stripe = new Stripe(functions.config().stripe?.secret as string, {
  apiVersion: "2024-06-20",
});

/**
 * إنشاء PaymentIntent لدفع Stripe
 * يتم استدعاؤه من Flutter App
 */
export const createPaymentIntent = functions.https.onCall(async (data, context) => {
  // التحقق من تسجيل الدخول
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "يجب تسجيل الدخول أولاً");
  }

  const amount = Number(data?.amount ?? 0);
  const currency = String(data?.currency ?? "sar");

  if (!amount || amount < 1) {
    throw new functions.https.HttpsError("invalid-argument", "amount is required");
  }

  try {
    const intent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: { enabled: true },
      metadata: {
        userId: context.auth.uid,
      },
    });

    return { clientSecret: intent.client_secret };
  } catch (error: any) {
    console.error("Error creating payment intent:", error);
    throw new functions.https.HttpsError("internal", "فشل إنشاء PaymentIntent");
  }
});

/**
 * إرسال بريد إلكتروني مع فاتورة الطلب
 */
export const sendOrderInvoice = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "يجب تسجيل الدخول أولاً");
  }

  const { orderId, userEmail, userName } = data;

  if (!orderId || !userEmail) {
    throw new functions.https.HttpsError("invalid-argument", "orderId and userEmail are required");
  }

  try {
    // جلب بيانات الطلب من Firestore
    const orderDoc = await admin.firestore().collection("orders").doc(orderId).get();
    
    if (!orderDoc.exists) {
      throw new functions.https.HttpsError("not-found", "الطلب غير موجود");
    }

    const orderData = orderDoc.data()!;
    
    // إنشاء محتوى البريد الإلكتروني
    const emailContent = generateInvoiceEmail(orderData, userName || userEmail);
    
    // إرسال البريد الإلكتروني
    // TODO: يجب إعداد SendGrid أو Nodemailer
    // حالياً، سنستخدم Firebase Extensions أو SendGrid
    console.log("Email content:", emailContent);
    console.log("To:", userEmail);
    
    // TODO: تفعيل إرسال البريد بعد إعداد SendGrid
    // await sendEmailViaSendGrid(userEmail, "فاتورة الطلب", emailContent);
    
    return { success: true, message: "تم إرسال الفاتورة بنجاح" };
  } catch (error: any) {
    console.error("Error sending invoice:", error);
    throw new functions.https.HttpsError("internal", "فشل إرسال البريد الإلكتروني");
  }
});

/**
 * دالة مساعدة لإنشاء محتوى البريد الإلكتروني
 */
function generateInvoiceEmail(orderData: any, userName: string): string {
  const orderId = orderData.id || "N/A";
  const totalCents = orderData.totalCents || 0;
  const totalSAR = (totalCents / 100).toFixed(2);
  const paymentMethod = orderData.paymentMethod === "stripe" ? "الدفع بالبطاقة المصرفية" : "الدفع عند الاستلام";
  const items = orderData.items || [];
  
  const itemsHtml = items.map((item: any, index: number) => {
    const itemPrice = ((item.priceCents || 0) / 100).toFixed(2);
    const itemTotal = ((item.priceCents || 0) * (item.quantity || 1) / 100).toFixed(2);
    return `
      <tr>
        <td style="padding: 8px; border-bottom: 1px solid #ddd;">${index + 1}</td>
        <td style="padding: 8px; border-bottom: 1px solid #ddd;">${item.nameAr || "N/A"}</td>
        <td style="padding: 8px; border-bottom: 1px solid #ddd;">${item.quantity || 0}</td>
        <td style="padding: 8px; border-bottom: 1px solid #ddd;">${itemPrice} ر.س</td>
        <td style="padding: 8px; border-bottom: 1px solid #ddd;">${itemTotal} ر.س</td>
      </tr>
    `;
  }).join("");

  return `
    <!DOCTYPE html>
    <html dir="rtl" lang="ar">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>فاتورة الطلب</title>
      <style>
        body { font-family: 'Cairo', Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #0D47A1; color: white; padding: 20px; text-align: center; }
        .content { background: #f9f9f9; padding: 20px; }
        .invoice-details { background: white; padding: 15px; margin: 15px 0; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th { background: #0D47A1; color: white; padding: 10px; text-align: right; }
        td { padding: 8px; text-align: right; }
        .total { font-size: 18px; font-weight: bold; color: #0D47A1; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>كنوز البحر - Sea Treasures</h1>
          <p>فاتورة الطلب</p>
        </div>
        
        <div class="content">
          <p>عزيزي/عزيزتي ${userName},</p>
          <p>شكراً لك على طلبك! إليك تفاصيل الطلب:</p>
          
          <div class="invoice-details">
            <p><strong>رقم الطلب:</strong> ${orderId}</p>
            <p><strong>طريقة الدفع:</strong> ${paymentMethod}</p>
            <p><strong>التاريخ:</strong> ${new Date().toLocaleDateString("ar-SA")}</p>
          </div>
          
          <h3>تفاصيل الطلب:</h3>
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>المنتج</th>
                <th>الكمية</th>
                <th>السعر</th>
                <th>الإجمالي</th>
              </tr>
            </thead>
            <tbody>
              ${itemsHtml}
            </tbody>
            <tfoot>
              <tr>
                <td colspan="4" style="text-align: left; font-weight: bold;">الإجمالي:</td>
                <td class="total">${totalSAR} ر.س</td>
              </tr>
            </tfoot>
          </table>
          
          <p>نتمنى لك يوم سعيد! 🌊</p>
        </div>
        
        <div class="footer">
          <p>كنوز البحر - Sea Treasures</p>
          <p>© ${new Date().getFullYear()} جميع الحقوق محفوظة</p>
        </div>
      </div>
    </body>
    </html>
  `;
}

/**
 * Webhook لمعالجة أحداث Stripe
 * يتم استدعاؤه تلقائياً عند نجاح الدفع
 */
export const stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers["stripe-signature"] as string;

  let event: Stripe.Event;

  try {
    const webhookSecret = functions.config().stripe?.webhook_secret;
    if (!webhookSecret) {
      console.error("Webhook secret not configured");
      res.status(400).send("Webhook secret not configured");
      return;
    }

    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err: any) {
    console.error("Webhook signature verification failed:", err.message);
    res.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  // معالجة الأحداث المختلفة
  switch (event.type) {
    case "payment_intent.succeeded":
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      console.log("Payment succeeded:", paymentIntent.id);
      
      // تحديث حالة الطلب في Firestore
      if (paymentIntent.metadata?.orderId) {
        await admin.firestore()
          .collection("orders")
          .doc(paymentIntent.metadata.orderId)
          .update({
            paymentStatus: "paid",
            stripePaymentIntentId: paymentIntent.id,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
      }
      break;

    case "payment_intent.payment_failed":
      const failedPayment = event.data.object as Stripe.PaymentIntent;
      console.log("Payment failed:", failedPayment.id);
      
      if (failedPayment.metadata?.orderId) {
        await admin.firestore()
          .collection("orders")
          .doc(failedPayment.metadata.orderId)
          .update({
            paymentStatus: "failed",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
      }
      break;

    default:
      console.log(`Unhandled event type: ${event.type}`);
  }

  res.json({ received: true });
});


