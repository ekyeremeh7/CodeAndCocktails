import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../api/tickets_api.dart';
import '../../models/err_success_model.dart';
import '../../shared/utils/enums.dart';
import 'results_data.dart';

class ResultsPage extends StatefulWidget {
  final Barcode? result;

  const ResultsPage({super.key, required this.result});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  // bool? verifyingTicket;
  VerificationStatus? verifyingTicket;

  ErrSuccResponse? results;

  @override
  void initState() {
    super.initState();
    _verifyingTicket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: (results?.ticketSuccess?.qrCodeBase64 ?? '').isNotEmpty
            ? Theme.of(context).primaryColor
            : const Color(0xffEA1154),
        onPressed: () {
          Navigator.pop(context);
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (builder) => const HomePage()),
          //     (route) => false);
        },
        child: Icon(
          (results?.ticketSuccess?.qrCodeBase64 ?? '').isNotEmpty
              ? Icons.done
              : Icons.close,
          color: Theme.of(context).canvasColor,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text(
          "Ticket Verification",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          verifyingTicket == VerificationStatus.success
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.confirmation_number,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildVerifyingTicketResponse(),
                      const SizedBox(height: 40),
                      Text(
                        "Click arrow to scan next ticket",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(
                            context,
                          ).disabledColor.withOpacity(.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
          verifyingTicket == VerificationStatus.success
              ? successWidget()
              : const SizedBox(),
        ],
      ),
    );
  }

  _buildVerifyingTicketResponse() {
    return verifyingTicket == VerificationStatus.loading
        ? loader()
        : verifyingTicket == VerificationStatus.error
        ? errorWidget(results!.error!.message ?? "Error verifying ticket")
        : verifyingTicket == VerificationStatus.usedUp
        ? usedUpWidget(context)
        : const SizedBox();
  }

  _verifyingTicket() {
    Future.microtask(() async {
      TicketSingleton ticketSingleton = TicketSingleton();

      setState(() {
        verifyingTicket = VerificationStatus.loading;
      });

      results = await ticketSingleton.verifyMyTicket(
        ticketID: widget.result?.code ?? '',
      );
      debugPrint("Results ${results!.ticketSuccess}");
      if (results == null) {
        setState(() {
          verifyingTicket = null;
        });
        return null;
      }

      if (results?.error == null) {
        debugPrint("RESP OK:");
        setState(() {
          verifyingTicket = VerificationStatus.success;
        });
      } else if (results?.error?.message == "Ticket is used up") {
        // Specific case when ticket is used up
        debugPrint("Ticket is used up");
        setState(() {
          verifyingTicket = VerificationStatus.usedUp;
        });
      } else {
        debugPrint("RESP ERR:");

        setState(() {
          verifyingTicket = VerificationStatus.error;
        });
      }
    });
  }

  loader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Verifying ticket...",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  successWidget() {
    return Column(
      children: [
        // const SizedBox(
        //   height: 30,
        // ),
        ResultsData(
          successResponse: results?.ticketSuccess,
          result: widget.result,
        ),
      ],
    );
  }

  errorWidget(String message) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  usedUpWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.block_outlined,
            size: 60,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Ticket Already Used",
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "This ticket has been scanned before",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
