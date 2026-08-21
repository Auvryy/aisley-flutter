import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/data/philippine_addresses.dart';
import '../../core/models/address.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/aisley_button.dart';
import '../../core/widgets/aisley_text_field.dart';
import '../../core/widgets/status_badge.dart';
import '../../state/buyer_state.dart';

class BuyerRegisterWizard extends StatefulWidget {
  const BuyerRegisterWizard({super.key});

  @override
  State<BuyerRegisterWizard> createState() => _BuyerRegisterWizardState();
}

class _BuyerRegisterWizardState extends State<BuyerRegisterWizard> {
  int _currentStep = 1;

  // Step 1: Personal Info
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleInitialController = TextEditingController();
  String _selectedSex = 'Female';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController =
      TextEditingController(text: '+63 917 ');
  final TextEditingController _birthdayController = TextEditingController();
  int _calculatedAge = 0;
  String? _ageError;

  // Step 2: Cascading Philippine Address
  String _selectedProvince = PHILIPPINE_ADDRESS_DATA[0].province;
  late String _selectedCity;
  late String _selectedBarangay;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  // Step 3: KYC ID Upload & Terms
  String _selectedIdType = 'PhilSys National ID';
  String? _uploadedIdFileName;
  String? _uploadedIdPreviewUrl;
  bool _termsAgreed = false;
  bool _isSubmitting = false;

  final List<String> _idTypes = [
    'PhilSys National ID',
    'Philippine Passport',
    "Driver's License",
    'Unified Multi-Purpose ID (UMID)',
    'Postal ID',
    'PRC Professional ID',
    "Voter's ID",
  ];

  final List<String> _sexOptions = [
    'Female',
    'Male',
    'Non-Binary',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final firstProv = PHILIPPINE_ADDRESS_DATA[0];
    final firstCity = firstProv.cities[0];
    _selectedCity = firstCity.name;
    _selectedBarangay = firstCity.barangays[0];
    _postalCodeController.text = firstCity.postalCode;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleInitialController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _birthdayController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _onProvinceChanged(String? newProvince) {
    if (newProvince == null) return;
    setState(() {
      _selectedProvince = newProvince;
      final prov = PHILIPPINE_ADDRESS_DATA.firstWhere((p) => p.province == newProvince);
      if (prov.cities.isNotEmpty) {
        _selectedCity = prov.cities[0].name;
        _selectedBarangay = prov.cities[0].barangays[0];
        _postalCodeController.text = prov.cities[0].postalCode;
      }
    });
  }

  void _onCityChanged(String? newCity) {
    if (newCity == null) return;
    setState(() {
      _selectedCity = newCity;
      final prov = PHILIPPINE_ADDRESS_DATA.firstWhere((p) => p.province == _selectedProvince);
      final city = prov.cities.firstWhere((c) => c.name == newCity);
      if (city.barangays.isNotEmpty) {
        _selectedBarangay = city.barangays[0];
        _postalCodeController.text = city.postalCode;
      }
    });
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 24, now.month, now.day),
      firstDate: DateTime(1930),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AisleyColors.accentPink,
              onPrimary: Colors.white,
              onSurface: AisleyColors.textDarkPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final isoStr = AisleyFormatters.toIsoDate(picked);
      _birthdayController.text = isoStr;
      final age = AisleyFormatters.calculateAge(isoStr);
      setState(() {
        _calculatedAge = age;
        if (age < 18) {
          _ageError = 'Aisley buyer accounts require an age of 18 or above.';
        } else {
          _ageError = null;
        }
      });
    }
  }

  void _handleAutoFill() {
    setState(() {
      _firstNameController.text = 'Victoria';
      _lastNameController.text = 'Zobel';
      _middleInitialController.text = 'M';
      _selectedSex = 'Female';
      _emailController.text = 'victoria.zobel@manila.ph';
      _contactNoController.text = '+63 917 889 4410';
      _birthdayController.text = '1995-08-14';
      _calculatedAge = AisleyFormatters.calculateAge('1995-08-14');
      _ageError = null;

      _selectedProvince = 'Metro Manila (NCR)';
      _selectedCity = 'Makati City';
      _selectedBarangay = 'Bel-Air';
      _streetController.text = 'Jupiter Street, Horizon Tower';
      _houseNumberController.text = 'Penthouse 12B';
      _postalCodeController.text = '1200';

      _selectedIdType = 'Philippine Passport';
      _uploadedIdFileName = 'Philippine_Passport_Victoria_Zobel.jpg';
      _uploadedIdPreviewUrl =
          'https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80';
      _termsAgreed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Auto-filled with verified VIP buyer test profile!'),
        backgroundColor: AisleyColors.emeraldSuccess,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _simulateUploadId() {
    setState(() {
      _uploadedIdFileName = '${_selectedIdType.replaceAll(' ', '_')}_Upload.jpg';
      _uploadedIdPreviewUrl =
          'https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80';
    });
  }

  void _handleNextStep() {
    if (_currentStep == 1) {
      if (_firstNameController.text.trim().isEmpty ||
          _lastNameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _birthdayController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required personal information fields.'),
            backgroundColor: AisleyColors.roseDanger,
          ),
        );
        return;
      }
      if (_calculatedAge < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buyer must be at least 18 years old to register.'),
            backgroundColor: AisleyColors.roseDanger,
          ),
        );
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_streetController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide your street or building details.'),
            backgroundColor: AisleyColors.roseDanger,
          ),
        );
        return;
      }
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      if (_uploadedIdFileName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a valid Government ID for admin verification.'),
            backgroundColor: AisleyColors.roseDanger,
          ),
        );
        return;
      }
      if (!_termsAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms of Service & Code of Conduct.'),
            backgroundColor: AisleyColors.roseDanger,
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        final address = PhilippineAddress(
          province: _selectedProvince,
          city: _selectedCity,
          barangay: _selectedBarangay,
          street: _streetController.text.trim(),
          houseNumber: _houseNumberController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
        );

        final state = BuyerStateProvider.of(context);
        state.registerBuyer(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          middleInitial: _middleInitialController.text.trim(),
          sex: _selectedSex,
          email: _emailController.text.trim(),
          contactNo: _contactNoController.text.trim(),
          birthday: _birthdayController.text.trim(),
          age: _calculatedAge,
          address: address,
          kycIdType: _selectedIdType,
          kycIdFileName: _uploadedIdFileName!,
          kycIdPreviewUrl: _uploadedIdPreviewUrl,
        );

        Navigator.of(context).pop(); // Back to root navigation which now displays approval tracker
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final provObj = PHILIPPINE_ADDRESS_DATA.firstWhere(
      (p) => p.province == _selectedProvince,
      orElse: () => PHILIPPINE_ADDRESS_DATA[0],
    );

    final cityObj = provObj.cities.firstWhere(
      (c) => c.name == _selectedCity,
      orElse: () => provObj.cities[0],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: _handleAutoFill,
            icon: const Icon(Icons.auto_awesome, size: 16, color: AisleyColors.accentPink),
            label: const Text(
              '1-Click Auto-Fill',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AisleyColors.accentPink,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step Progress Indicator
                _buildStepHeader(isDark),
                const SizedBox(height: 20),

                // Step Content Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AisleyColors.obsidianSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                    ),
                  ),
                  child: _buildStepContent(isDark, provObj, cityObj),
                ),
                const SizedBox(height: 20),

                // Navigation Buttons
                Row(
                  children: [
                    if (_currentStep > 1) ...[
                      Expanded(
                        child: AisleyButton(
                          text: 'Back',
                          variant: AisleyButtonVariant.outline,
                          leadingIcon: Icons.arrow_back_rounded,
                          onPressed: () => setState(() => _currentStep--),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: AisleyButton(
                        text: _currentStep == 3 ? 'Submit for Admin Verification' : 'Proceed to Step ${_currentStep + 1}',
                        isLoading: _isSubmitting,
                        trailingIcon: _currentStep == 3 ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
                        onPressed: _handleNextStep,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStepCircle(1, 'Personal', _currentStep >= 1, _currentStep == 1),
            _buildStepDivider(_currentStep >= 2),
            _buildStepCircle(2, 'Address', _currentStep >= 2, _currentStep == 2),
            _buildStepDivider(_currentStep >= 3),
            _buildStepCircle(3, 'ID Upload', _currentStep >= 3, _currentStep == 3),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          _currentStep == 1
              ? 'Step 1: Personal Identification'
              : _currentStep == 2
                  ? 'Step 2: Philippine Delivery Address'
                  : 'Step 3: Identity Verification & Terms',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _currentStep == 1
              ? 'Enter your legal identity. Buyers must be at least 18 years old.'
              : _currentStep == 2
                  ? 'Select your Philippine province, municipality, and barangay.'
                  : 'Upload an official government ID for administrator clearance.',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label, bool isCompleted, bool isCurrent) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AisleyColors.accentPink
                  : isCompleted
                      ? AisleyColors.emeraldSuccess
                      : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted && !isCurrent
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      '$step',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
              color: isCurrent ? AisleyColors.accentPink : AisleyColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(bool isPassed) {
    return Container(
      width: 28,
      height: 2,
      color: isPassed ? AisleyColors.emeraldSuccess : const Color(0xFFE2E8F0),
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  Widget _buildStepContent(bool isDark, PhilippineProvince provObj, PhilippineCity cityObj) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AisleyTextField(
                    label: 'First Name',
                    hint: 'e.g. Victoria',
                    isRequired: true,
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AisleyTextField(
                    label: 'Last Name',
                    hint: 'e.g. Zobel',
                    isRequired: true,
                    controller: _lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: AisleyTextField(
                    label: 'M.I.',
                    hint: 'M',
                    controller: _middleInitialController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Sex / Gender',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('*', style: TextStyle(color: AisleyColors.accentPink, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSex,
                        items: _sexOptions.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSex = val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AisleyTextField(
              label: 'Email Address',
              hint: 'victoria.zobel@manila.ph',
              isRequired: true,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.alternate_email, size: 18),
            ),
            const SizedBox(height: 14),
            AisleyTextField(
              label: 'Contact Number',
              hint: '+63 9XX XXX XXXX',
              isRequired: true,
              controller: _contactNoController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined, size: 18),
            ),
            const SizedBox(height: 14),
            // Birthday with real-time autogen age
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Birthday',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AisleyColors.accentPink, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (_calculatedAge > 0)
                      StatusBadge(
                        label: 'Age: $_calculatedAge yrs old',
                        type: _calculatedAge >= 18 ? BadgeType.success : BadgeType.danger,
                        icon: _calculatedAge >= 18 ? Icons.verified : Icons.error_outline,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickBirthday,
                  child: IgnorePointer(
                    child: AisleyTextField(
                      label: '',
                      hint: 'YYYY-MM-DD (Tap to select date)',
                      controller: _birthdayController,
                      prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                      errorText: _ageError,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Province selector
            const Text(
              'Province / Region',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedProvince,
              items: PHILIPPINE_ADDRESS_DATA.map((p) {
                return DropdownMenuItem(value: p.province, child: Text(p.province, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: _onProvinceChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // City selector
            const Text(
              'City / Municipality',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCity,
              items: provObj.cities.map((c) {
                return DropdownMenuItem(value: c.name, child: Text(c.name, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: _onCityChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Barangay selector
            const Text(
              'Barangay',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedBarangay,
              items: cityObj.barangays.map((b) {
                return DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBarangay = val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Street & House Number
            AisleyTextField(
              label: 'Street / Building Name',
              hint: 'e.g. Jupiter Street, Horizon Tower',
              isRequired: true,
              controller: _streetController,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AisleyTextField(
                    label: 'House / Unit No.',
                    hint: 'e.g. Penthouse 12B',
                    controller: _houseNumberController,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: AisleyTextField(
                    label: 'Postal Code',
                    hint: '1200',
                    controller: _postalCodeController,
                  ),
                ),
              ],
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Government ID Type',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedIdType,
              items: _idTypes.map((id) {
                return DropdownMenuItem(value: id, child: Text(id, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedIdType = val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Upload Box / Snapshot simulator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  if (_uploadedIdFileName != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AisleyColors.emeraldSuccess.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.badge, color: AisleyColors.emeraldSuccess),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _uploadedIdFileName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Ready for Admin Inspection • 1.4 MB',
                                style: TextStyle(fontSize: 11, color: AisleyColors.emeraldSuccess),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AisleyColors.roseDanger, size: 20),
                          onPressed: () {
                            setState(() {
                              _uploadedIdFileName = null;
                              _uploadedIdPreviewUrl = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    const Icon(Icons.cloud_upload_outlined, size: 36, color: AisleyColors.accentPink),
                    const SizedBox(height: 8),
                    const Text(
                      'Attach Front of Valid Government ID',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supported formats: JPG, PNG, PDF (Max 10MB)',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _simulateUploadId,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AisleyColors.obsidianSurface : Colors.white,
                            foregroundColor: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                            side: BorderSide(
                              color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt_outlined, size: 16),
                          label: const Text('Camera Snap', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _simulateUploadId,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AisleyColors.accentPink.withValues(alpha: 0.1),
                            foregroundColor: AisleyColors.accentPink,
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.folder_open_outlined, size: 16),
                          label: const Text('Choose File', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms Agreement
            Material(
              color: Colors.transparent,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AisleyColors.accentPink,
                value: _termsAgreed,
                onChanged: (val) => setState(() => _termsAgreed = val ?? false),
                title: const Text(
                  'I agree to the Aisley Buyer Terms of Service and Code of Conduct.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 8),

            // Official Submission disclaimer banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AisleyColors.pinkTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFBCFE8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, size: 18, color: AisleyColors.accentPink),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'After submitting your registration, please wait for the administrator\'s approval, which will be sent to your email.',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AisleyColors.accentPink,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
