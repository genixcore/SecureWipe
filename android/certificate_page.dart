import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Define the primary color token for use in the button style
  static const Color _primary = Color(0xFF094EBE);
  static const Color _bg = Color(0xFFF1F3F6); // Background color of the page

  // Person Performing Sanitization
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Media Information
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _mediaPropertyNumberController = TextEditingController();
  final TextEditingController _mediaTypeController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _classificationController = TextEditingController();
  bool _dataBackedUpYes = false;
  bool _dataBackedUpNo = false;
  bool _dataBackedUpUnknown = false;
  final TextEditingController _backupLocationController = TextEditingController();

  // Sanitization Details
  bool _methodClear = false;
  bool _methodPurge = false;
  bool _methodDamage = false;
  bool _methodDestruct = false;

  bool _usedDegauss = false;
  bool _usedOverwrite = false;
  bool _usedBlockErase = false;
  bool _usedCryptoErase = false;
  final TextEditingController _methodOtherController = TextEditingController();

  final TextEditingController _methodDetailsController = TextEditingController();
  final TextEditingController _toolUsedController = TextEditingController();

  bool _verificationFull = false;
  bool _verificationQuick = false;
  final TextEditingController _verificationOtherController = TextEditingController();

  final TextEditingController _postSanitizationClassificationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Media Destination
  bool _mediaInternalReuse = false;
  bool _mediaExternalReuse = false;
  bool _mediaRecyclingFacility = false;
  bool _mediaManufacturer = false;
  bool _mediaOther = false;
  final TextEditingController _mediaOtherDetailsController = TextEditingController();

  // Signature
  final TextEditingController _signatureController = TextEditingController();
  final TextEditingController _signatureDateController = TextEditingController();

  // Validation
  final TextEditingController _validationNameController = TextEditingController();
  final TextEditingController _validationTitleController = TextEditingController();
  final TextEditingController _validationOrganizationController = TextEditingController();
  final TextEditingController _validationLocationController = TextEditingController();
  final TextEditingController _validationPhoneController = TextEditingController();
  final TextEditingController _validationSignatureController = TextEditingController();
  final TextEditingController _validationDateController = TextEditingController();

  Widget _buildCheckbox(String label, bool value, void Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Flexible(child: Text(label, style: GoogleFonts.inter(fontSize: 14))),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        style: GoogleFonts.inter(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _organizationController.dispose();
    _locationController.dispose();
    _phoneController.dispose();

    _makeController.dispose();
    _modelNumberController.dispose();
    _serialNumberController.dispose();
    _mediaPropertyNumberController.dispose();
    _mediaTypeController.dispose();
    _sourceController.dispose();
    _classificationController.dispose();
    _backupLocationController.dispose();

    _methodOtherController.dispose();
    _methodDetailsController.dispose();
    _toolUsedController.dispose();

    _verificationOtherController.dispose();
    _postSanitizationClassificationController.dispose();
    _notesController.dispose();

    _mediaOtherDetailsController.dispose();

    _signatureController.dispose();
    _signatureDateController.dispose();

    _validationNameController.dispose();
    _validationTitleController.dispose();
    _validationOrganizationController.dispose();
    _validationLocationController.dispose();
    _validationPhoneController.dispose();
    _validationSignatureController.dispose();
    _validationDateController.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Certificate Generated'),
          content: const Text('All data has been recorded successfully.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionTitleStyle = GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate of Sanitization'),
        backgroundColor: _primary,
      ),
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PERSON PERFORMING SANITIZATION
                Text('PERSON PERFORMING SANITIZATION', style: sectionTitleStyle),
                _buildTextField('Name', _nameController),
                _buildTextField('Title', _titleController),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Organization', _organizationController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Location', _locationController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Phone', _phoneController)),
                  ],
                ),
                const SizedBox(height: 24),

                // MEDIA INFORMATION
                Text('MEDIA INFORMATION', style: sectionTitleStyle),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Make/ Vendor', _makeController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Model Number', _modelNumberController)),
                  ],
                ),
                _buildTextField('Serial Number', _serialNumberController),
                _buildTextField('Media Property Number', _mediaPropertyNumberController),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Media Type', _mediaTypeController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Source (user name or PC property number)', _sourceController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Classification', _classificationController)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Data Backed Up: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          Wrap( 
                            spacing: 8,
                            runSpacing: 0,
                            children: [
                              _buildCheckbox('Yes', _dataBackedUpYes, (v) => setState(() {
                                    _dataBackedUpYes = v ?? false;
                                    if (_dataBackedUpYes) {
                                      _dataBackedUpNo = false;
                                      _dataBackedUpUnknown = false;
                                    }
                                  })),
                              _buildCheckbox('No', _dataBackedUpNo, (v) => setState(() {
                                    _dataBackedUpNo = v ?? false;
                                    if (_dataBackedUpNo) {
                                      _dataBackedUpYes = false;
                                      _dataBackedUpUnknown = false;
                                    }
                                  })),
                              _buildCheckbox('Unknown', _dataBackedUpUnknown, (v) => setState(() {
                                    _dataBackedUpUnknown = v ?? false;
                                    if (_dataBackedUpUnknown) {
                                      _dataBackedUpYes = false;
                                      _dataBackedUpNo = false;
                                    }
                                  })),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildTextField('Backup Location', _backupLocationController),
                const SizedBox(height: 24),

                // SANITIZATION DETAILS
                Text('SANITIZATION DETAILS', style: sectionTitleStyle),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCheckbox('Clear', _methodClear, (v) => setState(() => _methodClear = v ?? false)),
                    _buildCheckbox('Purge', _methodPurge, (v) => setState(() => _methodPurge = v ?? false)),
                    _buildCheckbox('Damage', _methodDamage, (v) => setState(() => _methodDamage = v ?? false)),
                    _buildCheckbox('Destruct', _methodDestruct, (v) => setState(() => _methodDestruct = v ?? false)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCheckbox('Degauss', _usedDegauss, (v) => setState(() => _usedDegauss = v ?? false)),
                    _buildCheckbox('Overwrite', _usedOverwrite, (v) => setState(() => _usedOverwrite = v ?? false)),
                    _buildCheckbox('Block Erase', _usedBlockErase, (v) => setState(() => _usedBlockErase = v ?? false)),
                    _buildCheckbox('Crypto Erase', _usedCryptoErase, (v) => setState(() => _usedCryptoErase = v ?? false)),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: _methodOtherController,
                        decoration: const InputDecoration(labelText: 'Other'),
                      ),
                    ),
                  ],
                ),
                _buildTextField('Method Details', _methodDetailsController, maxLines: 3),
                _buildTextField('Tool Used (include version)', _toolUsedController),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCheckbox('Full', _verificationFull, (v) => setState(() => _verificationFull = v ?? false)),
                    _buildCheckbox('Quick Sampling', _verificationQuick, (v) => setState(() => _verificationQuick = v ?? false)),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: _verificationOtherController,
                        decoration: const InputDecoration(labelText: 'Other'),
                      ),
                    ),
                  ],
                ),
                _buildTextField('Post Sanitization Classification', _postSanitizationClassificationController),
                _buildTextField('Notes', _notesController, maxLines: 3),
                const SizedBox(height: 24),

                // MEDIA DESTINATION
                Text('MEDIA DESTINATION', style: sectionTitleStyle),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildCheckbox('Internal Reuse', _mediaInternalReuse, (v) => setState(() => _mediaInternalReuse = v ?? false)),
                    _buildCheckbox('External Reuse', _mediaExternalReuse, (v) => setState(() => _mediaExternalReuse = v ?? false)),
                    _buildCheckbox('Recycling Facility', _mediaRecyclingFacility, (v) => setState(() => _mediaRecyclingFacility = v ?? false)),
                    _buildCheckbox('Manufacturer', _mediaManufacturer, (v) => setState(() => _mediaManufacturer = v ?? false)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(value: _mediaOther, onChanged: (v) => setState(() => _mediaOther = v ?? false)),
                        const Text('Other (specify in details area)'),
                      ],
                    ),
                  ],
                ),
                if (_mediaOther) _buildTextField('Details', _mediaOtherDetailsController, maxLines: 2),
                const SizedBox(height: 24),

                // SIGNATURE
                Text('SIGNATURE', style: sectionTitleStyle),
                _buildTextField('Signature', _signatureController),
                _buildTextField('Date', _signatureDateController),
                const SizedBox(height: 24),

                // VALIDATION
                Text('VALIDATION', style: sectionTitleStyle),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Name', _validationNameController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Title', _validationTitleController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Organization', _validationOrganizationController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Location', _validationLocationController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Phone', _validationPhoneController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Signature', _validationSignatureController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Date', _validationDateController)),
                  ],
                ),

                const SizedBox(height: 24),

                // Certificate Image and Custom Widget
                Center(
                  child: Column(
                    children: [
                      const CertificateWidget(),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // MODIFIED BUTTON STYLE for clarity
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        backgroundColor: _primary, // Primary Blue
                        foregroundColor: Colors.white, // White Text
                        elevation: 6, // Added elevation for better visibility
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      child: const Text('Generate Certificate'),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CertificateWidget extends StatelessWidget {
  const CertificateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Certificate Details Go Here',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}