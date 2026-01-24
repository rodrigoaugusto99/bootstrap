import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool? obscureText;
  final bool enabled;
  final String? validationMessage;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Function(TapDownDetails details)? onTapDown;
  final bool isGrey;
  final bool floatingLabel;
  final bool hasArrowDown;
  final bool enableEdit;
  final String? errorText;
  final Function(String)? onChanged;
  final TextStyle? hintStyle;
  final bool hasHeight;
  final bool hasEye;
  final double? arrowDownSize;
  final Color? arrowDownColor;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final String? floatLabel;
  final int? maxLines;
  const CustomTextFormField({
    super.key,
    this.textInputAction,
    this.hasHeight = false,
    this.onChanged,
    this.hintStyle,
    this.errorText,
    this.onEditingComplete,
    this.validator,
    this.floatingLabel = false,
    this.hasArrowDown = false,
    this.hintText,
    this.validationMessage,
    this.onFieldSubmitted,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText,
    this.enabled = true,
    this.isGrey = false,
    this.enableEdit = false,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onTapDown,
    this.inputFormatters,
    this.hasEye = false,
    this.arrowDownSize,
    this.arrowDownColor,
    this.labelStyle,
    this.borderColor,
    this.floatLabel,
    this.maxLines,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool useObscure = true;
  String? _errorMessage;
  late AnimationController _errorAnimationController;
  late Animation<Offset> _errorSlideAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _errorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _errorSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _errorAnimationController,
      curve: Curves.easeOut,
    ));
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void onTapEye() {
    useObscure = !useObscure;
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _errorAnimationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _setError(String? error) {
    setState(() {
      _errorMessage = error;
      if (_errorMessage != null && _errorMessage!.isNotEmpty) {
        _errorAnimationController.forward();
      } else {
        _errorAnimationController.reverse();
      }
    });
  }

  Color get _disabledColor => Colors.black.withValues(alpha: 0.3);

  Color get _textColor {
    if (!widget.enabled) return _disabledColor;
    if (widget.isGrey) return _disabledColor;
    return Colors.black;
  }

  Color get _labelColor {
    if (!widget.enabled) return _disabledColor;
    if (!_isFocused && widget.labelStyle != null) {
      return widget.labelStyle!.color ?? const Color(0xff48464C);
    }
    if (_isFocused) return Colors.grey;
    return const Color(0xff48464C);
  }

  Color get _borderColor {
    if (!widget.enabled) return _disabledColor;
    if (widget.borderColor != null) return widget.borderColor!;
    return const Color(0xff79747E);
  }

  Color get _focusedBorderColor {
    if (!widget.enabled) return _disabledColor;
    if (widget.borderColor != null) return widget.borderColor!;
    if (_isFocused) return Colors.grey;
    return const Color(0xff79747E);
  }

  double get _focusedBorderWidth {
    if (!widget.enabled) return 1.0;
    if (_isFocused) return 2.7;
    return 1.0;
  }

  Color get _asteriskColor {
    if (!widget.enabled) return _disabledColor;
    return Colors.red;
  }

  TextStyle get _labelTextStyle {
    return TextStyle(
      fontFamily: 'Montserrat',
      color: _labelColor,
      fontSize: widget.floatLabel != null ? 14 : null,
    );
  }

  FloatingLabelBehavior? get _floatingLabelBehavior {
    if (widget.floatLabel != null) return FloatingLabelBehavior.always;
    if (widget.floatingLabel) return FloatingLabelBehavior.always;
    return null;
  }

  TextStyle get _finalLabelStyle {
    if (!_isFocused && widget.labelStyle != null) return widget.labelStyle!;
    return _labelTextStyle;
  }

  EdgeInsets get _contentPadding {
    return EdgeInsets.only(
      top: 16.0,
      bottom: 16.0,
      left: _isFocused ? 16.0 : 16,
    );
  }

  TextStyle get _finalHintStyle {
    if (widget.hintStyle != null) return widget.hintStyle!;
    return const TextStyle(
      fontSize: 16,
      color: Color(0xff79747E),
      fontWeight: FontWeight.w400,
      fontFamily: 'Montserrat',
    );
  }

  Widget? get _labelWidget {
    if (widget.floatLabel != null) {
      return _buildLabelWithRedAsterisk(widget.floatLabel!);
    }
    if (widget.label != null) {
      return _buildLabelWithRedAsterisk(widget.label!);
    }
    return null;
  }

  Widget? get _suffixIcon {
    if (_isFocused) return null;
    if (acessibilityEnabled(context)) return null;
    if (widget.enableEdit) {
      return const SizedBox(
        width: double.minPositive,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Editar',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: kcTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }
    return null;
  }

  double? get _height {
    if (widget.hasHeight) return 76;
    return null;
  }

  double get _eyeTopPadding {
    if (useObscure) return 20.5;
    return 18;
  }

  double get _arrowIconSize {
    if (widget.arrowDownSize != null) return widget.arrowDownSize!;
    return 20;
  }

  Color get _arrowIconColor {
    if (widget.arrowDownColor != null) return widget.arrowDownColor!;
    return Colors.black;
  }

  OutlineInputBorder _buildOutlineInputBorder({
    required Color color,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  OutlineInputBorder get _defaultBorder {
    return _buildOutlineInputBorder(color: _borderColor);
  }

  OutlineInputBorder get _focusedBorder {
    return _buildOutlineInputBorder(
      color: _focusedBorderColor,
      width: _focusedBorderWidth,
    );
  }

// PARA O CASO ONDE TEM ASTERISCO INDICANDO OBRIGATORIEADE
  Widget _buildLabelWithRedAsterisk(String text) {
    if (!text.contains('*')) {
      return Text(
        text,
        style: _labelTextStyle,
      );
    }

    final parts = text.split('*');
    if (parts.length == 1) {
      return Text(
        text,
        style: _labelTextStyle,
      );
    }

    return AppRichText(
      children: [
        TextSpan(
          text: parts[0],
          style: _labelTextStyle,
        ),
        TextSpan(
          text: '*',
          style: _labelTextStyle.copyWith(
            color: _asteriskColor,
          ),
        ),
        if (parts.length > 1)
          TextSpan(
            text: parts[1],
            style: _labelTextStyle,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      child: SizedBox(
        height: _height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (_errorMessage != null && _errorMessage!.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: -23,
                child: SlideTransition(
                  position: _errorSlideAnimation,
                  child: FadeTransition(
                    opacity: _errorAnimationController,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            TextFormField(
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              focusNode: widget.focusNode ?? _focusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: widget.onFieldSubmitted,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: useObscure && widget.hasEye,
              enabled: widget.enabled,
              style: TextStyle(
                color: _textColor,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Montserrat',
              ),
              validator: (value) {
                final error = widget.validator?.call(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _setError(error);
                });
                return error;
              },
              errorBuilder: (context, s) => const SizedBox.shrink(),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                suffixIcon: _suffixIcon,
                floatingLabelBehavior: _floatingLabelBehavior,
                labelStyle: _finalLabelStyle,
                hintText: widget.hintText,
                contentPadding: _contentPadding,
                label: _labelWidget,
                hintStyle: _finalHintStyle,
                border: _defaultBorder,
                disabledBorder: _defaultBorder,
                enabledBorder: _defaultBorder,
                focusedBorder: _focusedBorder,
              ),
            ),
            if (widget.hasEye)
              Align(
                alignment: Alignment.topRight,
                child: decContainer(
                  topPadding: _eyeTopPadding,
                  rightPadding: 18,
                  onTap: onTapEye,
                  color: Colors.transparent,
                ),
              ),
            if (widget.hasArrowDown)
              Align(
                alignment: Alignment.topRight,
                child: Transform.rotate(
                  angle: 3.14 * 0.5,
                  child: decContainer(
                    allPadding: 18,
                    topPadding: 24,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: _arrowIconSize,
                      color: _arrowIconColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
