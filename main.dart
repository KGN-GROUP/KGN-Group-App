import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String apiBase = String.fromEnvironment(
  'KGN_API',
  defaultValue: 'https://YOUR-API-DOMAIN.example.com',
);
const String inquiry = '+966568778195';
const String support = '+966541337646';
const String email = 'kgngroupinfo@gmail.com';
const String locationText = 'Al Qassim / Unaizah, Saudi Arabia';
const double leadFeeSar = 10;

const List<String> services = <String>[
  'Electronics',
  'CCTV & Security System',
  'Networking & Internet',
  'Telecommunication',
  'Video Door Phone',
  'Audio Door Phone',
  'Automation',
  'Smart Home',
  'Electrical',
  'AC & HVAC',
  'Home Appliances',
  'Preventive Maintenance',
  'Emergency Maintenance',
  'Renovation',
];

Future<void> openExternal(String raw) async {
  final Uri uri = Uri.parse(raw);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not open link');
  }
}

Future<void> callNumber(String number) => openExternal('tel:$number');
Future<void> openWhatsApp() =>
    openExternal('https://wa.me/966541337646');
Future<void> sendEmail() =>
    openExternal('mailto:$email?subject=KGN%20GROUP%20Inquiry');
Future<void> openMaps() => openExternal(
      'https://www.google.com/maps/search/?api=1&query=Unaizah%2C%20Al%20Qassim%2C%20Saudi%20Arabia',
    );

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KgnApp());
}

class KgnApp extends StatelessWidget {
  const KgnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KGN GROUP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KGN GROUP'),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: language,
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Arabic', child: Text('العربية')),
                DropdownMenuItem(value: 'Hindi', child: Text('हिन्दी')),
                DropdownMenuItem(value: 'Bengali', child: Text('বাংলা')),
              ],
              onChanged: (String? value) {
                if (value != null) setState(() => language = value);
              },
            ),
          ),
          Builder(
            builder: (BuildContext context) => IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const AppMenu(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/kgn_logo.png',
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.business, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _headline(language),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(locationText),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuotationPage()),
                  ),
                  icon: const Icon(Icons.request_quote),
                  label: const Text('Get Quotation'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: openWhatsApp,
                  icon: const Icon(Icons.chat),
                  label: const Text('WhatsApp'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text('Services', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...services.map(
            (String service) => Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.build)),
                title: Text(service),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ServicePage(name: service)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _headline(String value) {
    switch (value) {
      case 'Arabic':
        return 'حلول خدمات وصيانة احترافية';
      case 'Hindi':
        return 'प्रोफेशनल सर्विस और मेंटेनेंस समाधान';
      case 'Bengali':
        return 'পেশাদার সার্ভিস ও মেইনটেন্যান্স সমাধান';
      default:
        return 'Professional Service & Maintenance Solutions';
    }
  }
}

class AppMenu extends StatelessWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.business),
              title: Text('KGN GROUP', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(locationText),
            ),
            _item(context, Icons.home, 'Home', const HomePage()),
            _item(context, Icons.request_quote, 'Get Quotation', const QuotationPage()),
            _item(context, Icons.engineering, 'Vendor Registration / Login', const VendorPage()),
            _item(context, Icons.photo_library, 'Gallery', const GalleryPage()),
            _item(context, Icons.feedback, 'Feedback', const FeedbackPage()),
            _item(context, Icons.info, 'About Us', const AboutPage()),
            _item(context, Icons.contact_phone, 'Contact', const ContactPage()),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}

class ServicePage extends StatelessWidget {
  final String name;
  const ServicePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: <Color>[Color(0xFF111827), Color(0xFFF59E0B)]),
            ),
            child: const Icon(Icons.build_circle, color: Colors.white, size: 90),
          ),
          const SizedBox(height: 22),
          Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            'KGN GROUP provides professional $name installation, repair, maintenance and service solutions for residential, commercial and industrial requirements.',
            style: const TextStyle(fontSize: 17, height: 1.5),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuotationPage()),
            ),
            icon: const Icon(Icons.request_quote),
            label: const Text('Get Quotation'),
          ),
        ],
      ),
    );
  }
}

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController description = TextEditingController();
  String service = services.first;
  bool busy = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    location.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) {
      _message('Name and mobile are required.');
      return;
    }
    if (apiBase.contains('YOUR-API-DOMAIN')) {
      _message('API is not configured yet. Please contact KGN GROUP by WhatsApp.');
      return;
    }
    setState(() => busy = true);
    try {
      final http.Response response = await http.post(
        Uri.parse('$apiBase/leads'),
        headers: <String, String>{'content-type': 'application/json'},
        body: jsonEncode(<String, String>{
          'customerName': name.text.trim(),
          'customerPhone': phone.text.trim(),
          'location': location.text.trim(),
          'service': service,
          'description': description.text.trim(),
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _message('Request submitted successfully.');
      } else {
        throw Exception('Server error ${response.statusCode}');
      }
    } catch (e) {
      _message('Could not submit: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _message(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Quotation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: location, decoration: const InputDecoration(labelText: 'Service Location', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: service,
            decoration: const InputDecoration(labelText: 'Service', border: OutlineInputBorder()),
            items: services.map((String s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (String? v) => setState(() => service = v ?? services.first),
          ),
          const SizedBox(height: 12),
          TextField(controller: description, maxLines: 5, decoration: const InputDecoration(labelText: 'Requirement', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Submitting...' : 'Submit Requirement')),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: openWhatsApp, icon: const Icon(Icons.chat), label: const Text('Send by WhatsApp')),
        ],
      ),
    );
  }
}

class VendorPage extends StatefulWidget {
  const VendorPage({super.key});

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Map<String, PlatformFile?> files = <String, PlatformFile?>{
    'iqama': null,
    'passport': null,
    'education': null,
    'photo': null,
  };
  bool terms = false;
  bool busy = false;
  bool loginMode = false;
  bool otpSent = false;

  @override
  void dispose() {
    name.dispose();
    mobile.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> pick(String key) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: key == 'photo' ? FileType.image : FileType.custom,
      allowedExtensions: key == 'photo' ? null : <String>['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) setState(() => files[key] = result.files.single);
  }

  Future<void> submit() async {
    if (name.text.trim().isEmpty || mobile.text.trim().isEmpty || emailController.text.trim().isEmpty || !terms) {
      _message('Complete required fields and accept the Vendor Terms & Conditions.');
      return;
    }
    if (apiBase.contains('YOUR-API-DOMAIN')) {
      _message('API is not configured yet.');
      return;
    }
    setState(() => busy = true);
    try {
      final http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('$apiBase/vendors'));
      request.fields.addAll(<String, String>{
        'name': name.text.trim(),
        'mobile': mobile.text.trim(),
        'email': emailController.text.trim(),
        'termsAccepted': 'true',
      });
      for (final MapEntry<String, PlatformFile?> entry in files.entries) {
        final PlatformFile? file = entry.value;
        if (file?.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(entry.key, file!.bytes!, filename: file.name));
        }
      }
      final http.StreamedResponse response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _message('Application submitted. Pending admin approval.');
      } else {
        throw Exception('Server error ${response.statusCode}');
      }
    } catch (e) {
      _message('Could not submit: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _message(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Registration / Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment(value: false, label: Text('Registration')),
              ButtonSegment(value: true, label: Text('Login')),
            ],
            selected: <bool>{loginMode},
            onSelectionChanged: (Set<bool> value) => setState(() {
              loginMode = value.first;
              otpSent = false;
            }),
          ),
          const SizedBox(height: 18),
          if (!loginMode) ...<Widget>[
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Vendor Name *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder())),
            const SizedBox(height: 18),
            const Text('Upload Documents', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...files.keys.map(
              (String key) => Card(
                child: ListTile(
                  title: Text(key[0].toUpperCase() + key.substring(1)),
                  subtitle: Text(files[key]?.name ?? 'Not selected'),
                  trailing: IconButton(icon: const Icon(Icons.upload_file), onPressed: () => pick(key)),
                ),
              ),
            ),
            CheckboxListTile(
              value: terms,
              onChanged: (bool? value) => setState(() => terms = value ?? false),
              title: const Text('I accept KGN GROUP Vendor Terms & Conditions.'),
            ),
            const Text('Lead viewing charge: SAR 10 per accepted lead. Customer contact, photos and documents remain hidden until the lead is purchased/paid.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Submitting...' : 'Submit for Approval')),
          ] else ...<Widget>[
            const Text('Vendor Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile or Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            if (otpSent) const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'OTP', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => otpSent = true),
              child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
            const SizedBox(height: 8),
            const Text('OTP delivery must be connected to your production SMS/WhatsApp provider through the Lead API.', style: TextStyle(color: Colors.black54)),
          ],
          const Divider(height: 32),
          const Text('Vendor Communication', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: <Widget>[
              OutlinedButton.icon(onPressed: () => callNumber(support), icon: const Icon(Icons.call), label: const Text('Audio Call')),
              OutlinedButton.icon(onPressed: openWhatsApp, icon: const Icon(Icons.videocam), label: const Text('WhatsApp / Video')),
            ],
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemBuilder: (_, int index) => Card(
          child: Center(child: Icon(index.isEven ? Icons.photo_library : Icons.video_library, size: 50)),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedback = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text('Your Feedback', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: feedback, maxLines: 7, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write your feedback...')),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => openExternal('mailto:$email?subject=KGN%20GROUP%20Feedback&body=${Uri.encodeComponent(feedback.text)}'),
            icon: const Icon(Icons.send),
            label: const Text('Send Feedback'),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Text('KGN GROUP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            'KGN GROUP provides professional technical service, installation, repair, maintenance and renovation solutions in Al Qassim / Unaizah, Saudi Arabia. Our service portfolio covers electronics, electrical systems, AC & HVAC, CCTV and security, networking, telecommunications, door phones, automation, smart home systems, home appliances, preventive maintenance, emergency maintenance and renovation works.',
            style: TextStyle(fontSize: 17, height: 1.6),
          ),
          SizedBox(height: 20),
          Text('Vendor policy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Vendors are approved by KGN GROUP before receiving leads. Customer contact details and private customer documents are not disclosed to a vendor until the applicable lead purchase/payment is confirmed. Customers see only approved vendor information that KGN GROUP chooses to publish, such as vendor name and mobile number after the lead is purchased.'),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')), 
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const ListTile(leading: Icon(Icons.location_on), title: Text(locationText)),
          ListTile(leading: const Icon(Icons.phone), title: const Text('Inquiry'), subtitle: const Text(inquiry), onTap: () => callNumber(inquiry)),
          ListTile(leading: const Icon(Icons.support_agent), title: const Text('Customer Support / Business WhatsApp'), subtitle: const Text(support), onTap: () => callNumber(support)),
          ListTile(leading: const Icon(Icons.email), title: const Text(email), onTap: sendEmail),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: openWhatsApp, icon: const Icon(Icons.chat), label: const Text('WhatsApp')),
          OutlinedButton.icon(onPressed: openMaps, icon: const Icon(Icons.map), label: const Text('Google Location')),
        ],
      ),
    );
  }
}
