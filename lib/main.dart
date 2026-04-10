import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  // Load the environment variables
  await dotenv.load(fileName: "assets/.env");
  runApp(const KavachMeteorApp());
}

class MyApiService {
  // Instead of hardcoding 'AIza...', use this:
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'Key not found';
  
  void makeApiCall() {
    print("Using API Key: $apiKey");
    // Pass this apiKey variable to your Gemini/API client
  }
}
class KavachMeteorApp extends StatelessWidget {
  const KavachMeteorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kavach (Meteor)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF14B8A6), // Teal
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF14B8A6),
          secondary: Color(0xFFFBBF24), // Gold
          surface: Color(0xFF1E293B),
          background: Color(0xFF0A0E27),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E293B),
          selectedItemColor: Color(0xFF14B8A6),
          unselectedItemColor: Color(0xFF64748B),
        ),
        cardColor: const Color(0xFF1E293B),
      ),
      // START ON THE NEW LANDING PAGE
      home: const LandingScreen(),
    );
  }
}

// ==========================================
// NEW: SPLASH / LANDING SCREEN
// ==========================================
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E27), Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo/Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF14B8A6).withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF14B8A6).withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: const Icon(Icons.shield_outlined, size: 100, color: Color(0xFF14B8A6)),
              ),
              const SizedBox(height: 40),
              
              // App Name
              const Text(
                'KAVACH',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: Colors.white,
                ),
              ),
              const Text(
                'by Meteor',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFBBF24),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              
              // Tagline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Your AI Financial Guardian.\nScan schemes to detect scams. Turn daily expenses into generational wealth.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              
              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF14B8A6).withOpacity(0.5),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MAIN NAVIGATION (HOME SCREEN)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English', 'Hindi', 'Bengali', 'Marathi', 'Telugu', 
    'Tamil', 'Gujarati', 'Urdu', 'Punjabi', 'Malayalam',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Color(0xFF14B8A6)),
            const SizedBox(width: 8),
            const Text('Kavach', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E27),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF14B8A6), width: 1.5),
            ),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              dropdownColor: const Color(0xFF1E293B),
              icon: const Icon(Icons.language, color: Color(0xFF14B8A6)),
              style: const TextStyle(color: Color(0xFF14B8A6), fontSize: 14, fontWeight: FontWeight.w600),
              items: _languages.map((String language) {
                return DropdownMenuItem<String>(value: language, child: Text(language));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) setState(() => _selectedLanguage = newValue);
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SchemeScannerScreen(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
          ),
          WealthEngineScreen(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
          ),
          // 🔴 CHANGE HERE: Pass the index so the screen knows when it is clicked
          HistoryScreen(currentTab: _currentIndex), 
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wealth'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: SCHEME SCANNER
// ==========================================
class SchemeScannerScreen extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const SchemeScannerScreen({super.key, required this.selectedLanguage, required this.onLanguageChanged});

  @override
  State<SchemeScannerScreen> createState() => _SchemeScannerScreenState();
}

class _SchemeScannerScreenState extends State<SchemeScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _analysisResult;
  bool _isLoading = false;

  // Load keys from .env
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _nvidiaApiKey = dotenv.env['NVIDIA_API_KEY'] ?? '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _analysisResult = null;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _analyzeScheme() async {
    if (_imageBytes == null) return _showError('Please select an image first');

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final String base64Image = base64Encode(_imageBytes!);
      
      // UPGRADED SCANNER PROMPT
      final String promptText = """You are Kavach (Meteor), a blunt and highly protective AI financial shield for everyday Indians.
Task: Analyze this investment scheme document/pamphlet.
CRITICAL: Translate the entire response strictly into ${widget.selectedLanguage}.
Output Format: Be highly minimalistic. Use short bullet points and clean Markdown Tables.

Provide exactly this structure:

### 🛡️ Kavach Safety Score
[🟢 Safe / 🟡 Caution / 🔴 High Risk / ☠️ SCAM] - One punchy sentence explaining the biggest catch.

### 🔍 The Fine Print Exposed
* **Lock-in Period:** [How many years are you trapped?]
* **Hidden Charges:** [Entry/Exit loads, commission percentages, agent fees]
* **Guarantees vs Reality:** [Are the returns actually guaranteed or just "illustrative"?]

### 💰 Real Expected Returns
Calculate realistic numbers, ignoring marketing fluff.
| Scheme/Asset | Monthly Invest | Promised % | Realistic % | 5-Year Value |
|--------------|----------------|------------|-------------|--------------|
| [Name] | ₹[Amount] | [%] | [%] | ₹[Value] |

### ✅ Bottom Line
A brutally honest 1-sentence verdict on whether a middle-class family should invest their hard-earned money here.""";

      http.Response response;

      try {
        response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_geminiApiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"contents": [{"parts": [{"text": promptText}, {"inline_data": {"mime_type": "image/jpeg", "data": base64Image}}]}]}),
        );
        if (response.statusCode != 200) throw Exception('Gemini Failed: ${response.statusCode}');
      } catch (e) {
        response = await http.post(
          Uri.parse('https://integrate.api.nvidia.com/v1/chat/completions'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_nvidiaApiKey'},
          body: jsonEncode({
            "model": "meta/llama-3.2-90b-vision-instruct",
            "messages": [{"role": "user", "content": [{"type": "text", "text": promptText}, {"type": "image_url", "image_url": {"url": "data:image/jpeg;base64,$base64Image"}}]}]
          }),
        );
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String text = jsonResponse.containsKey('candidates') 
            ? jsonResponse['candidates'][0]['content']['parts'][0]['text'] 
            : jsonResponse['choices'][0]['message']['content'];

        setState(() {
          _analysisResult = text;
          _isLoading = false;
        });
        await _saveToHistory('Scheme Scan', text);
      } else {
        throw Exception('API Error');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Analysis failed: $e');
    }
  }

  Future<void> _saveToHistory(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    history.insert(0, jsonEncode({'title': title, 'content': content, 'date': DateTime.now().toIso8601String(), 'language': widget.selectedLanguage}));
    await prefs.setStringList('history', history);
  }

  void _showError(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF14B8A6).withOpacity(0.2), const Color(0xFFFBBF24).withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF14B8A6).withOpacity(0.3), width: 1),
            ),
            child: const Column(
              children: [
                Icon(Icons.document_scanner, size: 48, color: Color(0xFF14B8A6)),
                SizedBox(height: 12),
                Text('Scan Any Investment Scheme', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Upload a photo to detect hidden risks and true returns.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildBtn(icon: Icons.camera_alt, label: 'Camera', onPressed: () => _pickImage(ImageSource.camera))),
              const SizedBox(width: 12),
              Expanded(child: _buildBtn(icon: Icons.photo_library, label: 'Gallery', onPressed: () => _pickImage(ImageSource.gallery))),
            ],
          ),
          const SizedBox(height: 24),
          if (_imageBytes != null)
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF14B8A6), width: 2),
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.memory(_imageBytes!, fit: BoxFit.cover)),
            ),
          if (_imageBytes != null) const SizedBox(height: 24),
          if (_imageBytes != null)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _analyzeScheme,
              icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) : const Icon(Icons.analytics),
              label: Text(_isLoading ? 'Scanning...' : 'Analyze Scheme', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B8A6), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 18)),
            ),
          if (_analysisResult != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFBBF24), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.verified_user, color: Color(0xFFFBBF24)),
                    SizedBox(width: 12),
                    Text('Kavach Verdict', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: _analysisResult!,
                    styleSheet: MarkdownStyleSheet(
                      h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6), height: 2),
                      p: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFFE2E8F0)),
                      tableHead: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6)),
                      tableBody: const TextStyle(fontSize: 12, color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBtn({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed, icon: Icon(icon), label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B), foregroundColor: const Color(0xFF14B8A6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFF14B8A6), width: 1.5),
      ),
    );
  }
}

// ==========================================
// TAB 2: WEALTH ENGINE
// ==========================================
class WealthEngineScreen extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const WealthEngineScreen({super.key, required this.selectedLanguage, required this.onLanguageChanged});

  @override
  State<WealthEngineScreen> createState() => _WealthEngineScreenState();
}

class _WealthEngineScreenState extends State<WealthEngineScreen> {
  bool _isConnected = false;
  bool _isConnecting = false;

  final List<Map<String, dynamic>> _expenses = [
    {'name': 'Zomato', 'amount': 450, 'icon': Icons.restaurant, 'color': 0xFFE23744},
    {'name': 'Netflix', 'amount': 199, 'icon': Icons.movie, 'color': 0xFFE50914},
    {'name': 'Swiggy', 'amount': 300, 'icon': Icons.delivery_dining, 'color': 0xFFFC8019},
  ];

  String? _nudgeText;
  bool _isLoading = false;

  // Load keys from .env
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _nvidiaApiKey = dotenv.env['NVIDIA_API_KEY'] ?? '';

  int get _totalLeaked => _expenses.fold(0, (sum, expense) => sum + (expense['amount'] as int));

  Future<void> _simulateUPIConnection() async {
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(milliseconds: 2500));
    setState(() { _isConnected = true; _isConnecting = false; });
  }

  void _showAddExpenseDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Merchant Name')),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                setState(() {
                  _expenses.add({'name': nameController.text, 'amount': int.parse(amountController.text), 'icon': Icons.receipt, 'color': 0xFF14B8A6});
                  _nudgeText = null;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _findInvestmentOpportunities() async {
    setState(() { _isLoading = true; _nudgeText = null; });

    try {
      final expenseList = _expenses.map((e) => '${e['name']}: ₹${e['amount']}').join(', ');
      
      // UPGRADED OMNI-ASSET WEALTH ENGINE PROMPT
      final String promptText = """You are Kavach, a top-tier Indian wealth manager.
Task: The user leaked ₹$_totalLeaked this week on: $expenseList.
CRITICAL: Translate the response into ${widget.selectedLanguage}.

Instructions:
1. Analyze the ₹$_totalLeaked leak.
2. Suggest the TOP 5 absolute best investment vehicles mixing ALL domains (Govt Schemes, Stocks, Index Funds, Bonds).
3. EXAMPLES: Nifty 50 ETF, PPF, Sovereign Gold Bonds (SGB), Reliance/Tata Bluechip, Liquid Mutual Funds.
4. STRICT: Use accurate Indian market rates (e.g., PPF is 7.1%, Nifty 50 historical avg is ~12%). Do not invent numbers. Calculate compound interest accurately.

Output Format (Markdown Only):
### 💸 The Leak Analysis
One empathetic sentence on their specific spending pattern.

### 📈 The Kavach Top 5 Portfolio
Based on your leaked amount (₹$_totalLeaked/week), here are 5 ways to build long-term wealth:
| Domain | Asset Name | Return % | 5-Year Value | 10-Year Value | Risk |
|--------|------------|----------|--------------|---------------|------|
| [e.g., Index Fund] | [e.g., Nifty 50 ETF] | **[%]** | ₹**[Calc]** | ₹**[Calc]** | [Risk] |
| [e.g., Govt Scheme] | [e.g., PPF] | **[%]** | ₹**[Calc]** | ₹**[Calc]** | [Risk] |

### 💡 Action Plan
A 2-sentence step-by-step guide on which app/platform to use to open the first recommended account today.""";

      http.Response response;
      try {
        response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_geminiApiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"contents": [{"parts": [{"text": promptText}]}]}),
        );
        if (response.statusCode != 200) throw Exception('Gemini Failed');
      } catch (e) {
        response = await http.post(
          Uri.parse('https://integrate.api.nvidia.com/v1/chat/completions'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_nvidiaApiKey'},
          body: jsonEncode({"model": "meta/llama-3.2-90b-vision-instruct", "messages": [{"role": "user", "content": promptText}], "max_tokens": 1024}),
        );
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String text = jsonResponse.containsKey('candidates') ? jsonResponse['candidates'][0]['content']['parts'][0]['text'] : jsonResponse['choices'][0]['message']['content'];

        setState(() { _nudgeText = text; _isLoading = false; });
        
        final prefs = await SharedPreferences.getInstance();
        final history = prefs.getStringList('history') ?? [];
        history.insert(0, jsonEncode({'title': 'Wealth Portfolio', 'content': text, 'date': DateTime.now().toIso8601String(), 'language': widget.selectedLanguage}));
        await prefs.setStringList('history', history);
      } else {
        throw Exception('API Error');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, size: 80, color: Color(0xFF64748B)),
              const SizedBox(height: 24),
              const Text('Connect Your Bank', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Kavach securely analyzes your UPI history to find hidden wealth opportunities. We do not store data.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), height: 1.5)),
              const SizedBox(height: 32),
              _isConnecting 
                ? const CircularProgressIndicator(color: Color(0xFF14B8A6))
                : ElevatedButton.icon(
                    onPressed: _simulateUPIConnection,
                    icon: const Icon(Icons.security), label: const Text('Link via PhonePe / GPay'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B8A6), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent UPI Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle, color: Color(0xFF14B8A6)), onPressed: _showAddExpenseDialog)
            ],
          ),
          const SizedBox(height: 16),
          ..._expenses.asMap().entries.map((entry) {
            final int index = entry.key;
            final expense = entry.value;
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => setState(() { _expenses.removeAt(index); _nudgeText = null; }),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155), width: 1)),
                child: Row(
                  children: [
                    Icon(expense['icon'] as IconData, color: Color(expense['color'] as int)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(expense['name'] as String, style: const TextStyle(fontSize: 16))),
                    Text('₹${expense['amount']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFFBBF24).withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Identifiable Leak:', style: TextStyle(fontSize: 16, color: Color(0xFFFBBF24))),
                Text('₹$_totalLeaked', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _expenses.isEmpty || _isLoading ? null : _findInvestmentOpportunities,
            icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) : const Icon(Icons.auto_awesome),
            label: const Text('Generate Wealth Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBBF24), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 18)),
          ),
          if (_nudgeText != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF14B8A6), width: 1.5)),
              child: MarkdownBody(
                data: _nudgeText!,
                styleSheet: MarkdownStyleSheet(
                  h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6), height: 2),
                  p: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFFE2E8F0)),
                  tableHead: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                  tableBody: const TextStyle(fontSize: 12, color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// TAB 3: HISTORY
// ==========================================
// ==========================================
// TAB 3: HISTORY (Reactive Fix)
// ==========================================
class HistoryScreen extends StatefulWidget {
  final int currentTab; // <-- ADDED THIS
  const HistoryScreen({super.key, required this.currentTab});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<SharedPreferences> _prefsFuture;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  // --- 🔴 THE FIX IS HERE ---
  // This listens for tab clicks. If you click Tab 2 (History), it instantly fetches fresh data!
  @override
  void didUpdateWidget(HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTab == 2 && oldWidget.currentTab != 2) {
      setState(() {
        _prefsFuture = SharedPreferences.getInstance();
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Clear')),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('history');
      setState(() => _prefsFuture = SharedPreferences.getInstance());
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today, ${DateFormat('h:mm a').format(date)}';
    if (difference.inDays == 1) return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
        final prefs = snapshot.data;
        final historyStrings = prefs?.getStringList('history') ?? [];
        final historyItems = historyStrings.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20), margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF14B8A6).withOpacity(0.2), const Color(0xFFFBBF24).withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF14B8A6).withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF14B8A6).withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.history, color: Color(0xFF14B8A6), size: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Vault', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${historyItems.length} saved analyses', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                      ],
                    ),
                  ),
                  if (historyItems.isNotEmpty) IconButton(onPressed: _clearHistory, icon: const Icon(Icons.delete_outline), color: Colors.red[400]),
                ],
              ),
            ),
            Expanded(
              child: historyItems.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inbox, size: 80, color: Colors.grey[700]), const SizedBox(height: 16), Text('No history yet', style: TextStyle(fontSize: 18, color: Colors.grey[600]))]))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        final item = historyItems[index];
                        final isExpanded = _expandedIndex == index;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: isExpanded ? const Color(0xFF14B8A6) : Colors.transparent, width: 2)),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: item['title'] == 'Scheme Scan' ? const Color(0xFF14B8A6).withOpacity(0.2) : const Color(0xFFFBBF24).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                  child: Icon(item['title'] == 'Scheme Scan' ? Icons.shield : Icons.trending_up, color: item['title'] == 'Scheme Scan' ? const Color(0xFF14B8A6) : const Color(0xFFFBBF24)),
                                ),
                                title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(_formatDate(item['date']), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                  ],
                                ),
                                trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: const Color(0xFF14B8A6)),
                              ),
                              if (isExpanded)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF334155), width: 1))),
                                  child: MarkdownBody(
                                    data: item['content'],
                                    styleSheet: MarkdownStyleSheet(
                                      h3: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6), height: 2),
                                      p: const TextStyle(fontSize: 12, height: 1.5, color: Color(0xFFE2E8F0)),
                                      tableBody: const TextStyle(fontSize: 11, color: Color(0xFFE2E8F0)),
                                      tableHead: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF14B8A6)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}