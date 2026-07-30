// main.ts
import { Worker } from 'worker_threads';
import path from 'path';

interface Order {
  id: string;
  items: { productId: string; quantity: number }[];
  customerEmail: string;
}

const exampleOrder: Order = {
  id: 'ORDER12345',
  items: [
    { productId: 'SKU1001', quantity: 2 },
    { productId: 'SKU2002', quantity: 1 },
  ],
  customerEmail: 'customer@example.com',
};

function processOrder(order: Order) {
  const workerPath = path.resolve(__dirname, 'invoiceWorker.js');
  const worker = new Worker(workerPath, { workerData: order });
  worker.on('message', (msg) => { console.log(`Main: Received message from worker for order ${order.id} ->`, msg); });
  worker.on('error', (err) => { console.error(`Main: Worker error on order ${order.id} ->`, err); });
  worker.on('exit', (code) => { if (code !== 0) console.error(`Main: Worker stopped with exit code ${code} for order ${order.id}`); });
}

processOrder(exampleOrder);


// invoiceWorker.ts
import { parentPort, workerData } from 'worker_threads';
import PDFDocument from 'pdfkit';
import fs from 'fs';
import nodemailer from 'nodemailer';

interface Order {
  id: string;
  items: { productId: string; quantity: number }[];
  customerEmail: string;
}

async function generateInvoice(order: Order): Promise<string> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const filename = `invoice-${order.id}.pdf`;
    const stream = fs.createWriteStream(filename);

    doc.pipe(stream);
    doc.fontSize(20).text('Invoice', { align: 'center' });
    doc.moveDown();
    doc.fontSize(12).text(`Order ID: ${order.id}`);
    doc.moveDown();

    order.items.forEach((item) => {
      doc.text(`${item.productId} x ${item.quantity}`);
    });

    doc.end();
    stream.on('finish', () => resolve(filename));
    stream.on('error', (err) => reject(err));
  });
}

async function sendEmail(to: string, attachmentPath: string) {
  const transporter = nodemailer.createTransport({
    host: 'smtp.example.com',
    port: 587,
    secure: false,
    auth: { user: 'user', pass: 'pass' },
  });

  await transporter.sendMail({
    from: 'sales@example.com',
    to,
    subject: 'Your Order Invoice',
    text: 'Please find attached your invoice.',
    attachments: [{ filename: path.basename(attachmentPath), path: attachmentPath }],
  });
}

(async () => {
  try {
    const order: Order = workerData;
    const invoicePath = await generateInvoice(order);
    await sendEmail(order.customerEmail, invoicePath);
    parentPort?.postMessage({ status: 'done', invoice: invoicePath });
  } catch (error) {
    parentPort?.postMessage({ status: 'error', error });
  }
})();
