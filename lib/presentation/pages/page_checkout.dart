import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/main.dart';
import 'package:pharmacy/resources/controller_basket.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final BasketController controller = Get.find();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("send_order_request".tr, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(
                          color: Colors.blue,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("text2".tr, style: const TextStyle(color: Colors.blue)),
                      )),
                  TextFormField(
                    initialValue: "~${controller.basketState.value?.total ?? 0}",
                    readOnly: true,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'approximate_total'.tr,
                      suffixText: "TMT",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumber,
                      readOnly: _isLoading,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'phone'.tr,
                        prefixText: "+993 ",
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty || value.length != 8 || !RegExp(r'^\d{8}$').hasMatch(value)) {
                          return 'fill_up'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _address,
                    readOnly: _isLoading,
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'address'.tr),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'fill_up'.tr;
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: TextFormField(
                      controller: _description,
                      readOnly: _isLoading,
                      maxLines: 4,
                      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'description'.tr),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 180,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                            disabledBackgroundColor: Colors.blue.shade400,
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState?.validate() == false) return;
                                  setState(() { _isLoading = true; });
                                  try {
                                    await controller.postCheckout(PostOrderRequestDto(clientName: "", phoneToContact: "+933${_phoneNumber.text}", address: _address.text, description: _description.text));
                                    await controller.refreshBasket();
                                    Get.back(result: true);
                                  } on Exception catch (error, _) {
                                    Fluttertoast.showToast(
                                        msg: errorFormat(error.toString()),
                                        backgroundColor: Colors.red,
                                        gravity: ToastGravity.TOP);
                                  }
                                  setState(() { _isLoading = false; });
                                },
                          child: _isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                              : Text("confirm".tr)),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
