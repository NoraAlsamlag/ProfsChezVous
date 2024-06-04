import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import '../../../components/format_date.dart';
import '../../../models/transaction_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PageDetailTransaction extends StatelessWidget {
  final Transaction transaction;

  PageDetailTransaction({required this.transaction});

final formatMonnaie = NumberFormat.currency(
  locale: 'fr_MR',
  symbol: 'MRU',
  decimalDigits: 2,
);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Détails de la transaction'),
      actions: [
        IconButton(
          icon: const Icon(Icons.print),
          onPressed: () {
            _imprimerTransaction(context);
          },
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _construireEntete(context), // Pass the context parameter
          const SizedBox(height: 16),
          _construireDetailTuile('Montant', formatMonnaie.format(transaction.montant)),
          _construireDetailTuile('Montant professionnel', formatMonnaie.format(transaction.montantProf)),
          _construireDetailTuile('Montant administratif', formatMonnaie.format(transaction.montantAdmin)),
          _construireDetailTuile('Date de création', formatDate(transaction.dateCreation)),
          _construireDetailTuile('Statut', transaction.statut),
        ],
      ),
    ),
  );
}

Widget _construireEntete(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ID de la transaction',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          transaction.idTransaction,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    ),
  );
}

  Widget _construireDetailTuile(String label, String valeur) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            valeur,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  void _imprimerTransaction(BuildContext context) async {
  final pdf = pw.Document();

  final logoImage = (await rootBundle.load('assets/images/logo.jpg')).buffer.asUint8List();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(logoImage), width: 50, height: 50),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'ProfsChezVous',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  'Détails de la transaction',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'ProfsChezVous est une plateforme en ligne qui met en relation les professionnels avec leurs clients. Nous fournissons des services de qualité et de faciliter les échanges entre les deux parties.',
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'ID de la transaction : ${transaction.idTransaction}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            _construireLignePdf('Montant', formatMonnaie.format(transaction.montant)),
            _construireLignePdf('Montant professionnel', formatMonnaie.format(transaction.montantProf)),
            _construireLignePdf('Montant administratif', formatMonnaie.format(transaction.montantAdmin)),
            _construireLignePdf('Date de création', formatDate(transaction.dateCreation)),
            _construireLignePdf('Statut', transaction.statut),
          ],
        );
      },
    ),
  );

  final pdfBytes = await pdf.save();
  final fileName = 'transaction_${transaction.idTransaction}.pdf';
  await Printing.sharePdf(bytes: pdfBytes, filename: fileName);

  final snackBar = const SnackBar(content: Text('Impression des détails de la transaction en cours...'));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  pw.Widget _construireLignePdf(String label, String valeur) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          '$label : ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(valeur),
      ],
    );
  }
}