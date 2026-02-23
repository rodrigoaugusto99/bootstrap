import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NumberStep extends StatefulWidget {
  const NumberStep({
    super.key,
  });

  @override
  State<NumberStep> createState() => _NumberStepState();
}

class _NumberStepState extends State<NumberStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // late Animation<double> backButtonFade;
  // late Animation<Offset> backButtonSlide;

  late Animation<double> firstColumnFade;
  late Animation<Offset> firstColumnSlide;

  late Animation<double> phoneFieldFade;
  late Animation<Offset> phoneFieldSlide;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Curve curve = Curves.easeOutCirc;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    //SLIDE 0 - 0.7
    firstColumnFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.5, curve: curve),
    );
    firstColumnSlide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: curve),
    ));

    //SLIDE 0.08 - 0.7
    // backButtonFade = CurvedAnimation(
    //   parent: _controller,
    //   curve: Interval(0.08, 0.7, curve: curve),
    // );
    // backButtonSlide = Tween(
    //   begin: const Offset(0, 1),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Interval(0.08, 0.7, curve: curve),
    // ));

    //SLIDE 0.08 - 0.7
    phoneFieldFade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.7, curve: curve),
    );
    phoneFieldSlide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.08, 0.7, curve: curve),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          // FadeTransition(
          //   opacity: backButtonFade,
          //   child: SlideTransition(
          //       position: backButtonSlide,
          //       child: const Icon(
          //         Icons.arrow_back,
          //         color: Colors.black,
          //       )),
          // ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: firstColumnFade,
            child: SlideTransition(
              position: firstColumnSlide,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your number',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A verification code will be sent via SMS',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: phoneFieldFade,
            child: SlideTransition(
              position: phoneFieldSlide,
              child: CustomTextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
