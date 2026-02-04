import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../main.dart';
import '../utils/responsive.dart';

/// Currency converter screen with Stripe-like design
///
/// Features:
/// - Clean white hierarchy design
/// - Hero section with two currency inputs (left and right)
/// - Swap button in center
/// - Currency picker dropdowns
/// - Real-time conversion
class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _fromAmountController = TextEditingController(text: '100');
  final TextEditingController _toAmountController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  
  // Initialize with fallback currencies so dropdowns work immediately
  List<String> _availableCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR',
    'BRL', 'MXN', 'KRW', 'SGD', 'HKD', 'NZD', 'SEK', 'NOK', 'DKK',
    'PLN', 'TRY', 'RUB', 'ZAR', 'AED', 'SAR',
  ];
  bool _isLoadingCurrencies = false;
  bool _isConverting = false;
  String? _error;
  
  double? _exchangeRate;
  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _fromAmountController.addListener(_onAmountChanged);
    _loadCurrencies();
    _convertCurrency();
  }

  @override
  void dispose() {
    _fromAmountController.removeListener(_onAmountChanged);
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoadingCurrencies = true;
      _error = null;
    });

    try {
      final response = await client.currency.getSupportedCurrencies();
      // Remove duplicates, ensure selected currencies are included, and sort
      final currenciesSet = response.currencies.toSet();
      currenciesSet.add(_fromCurrency); // Ensure from currency is in list
      currenciesSet.add(_toCurrency); // Ensure to currency is in list
      final currenciesList = currenciesSet.toList()..sort();
      
      setState(() {
        _availableCurrencies = currenciesList;
        _isLoadingCurrencies = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load currencies: $e';
        _isLoadingCurrencies = false;
        // Keep fallback currencies (already initialized)
        // Ensure selected currencies are in the list
        if (!_availableCurrencies.contains(_fromCurrency)) {
          _availableCurrencies.add(_fromCurrency);
        }
        if (!_availableCurrencies.contains(_toCurrency)) {
          _availableCurrencies.add(_toCurrency);
        }
        _availableCurrencies.sort();
      });
    }
  }

  void _onAmountChanged() {
    _convertCurrency();
  }

  Future<void> _convertCurrency() async {
    final amountText = _fromAmountController.text.trim();
    if (amountText.isEmpty || amountText == '0' || _fromCurrency == _toCurrency) {
      setState(() {
        _toAmountController.text = '';
        _exchangeRate = null;
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      return;
    }

    setState(() {
      _isConverting = true;
      _error = null;
    });

    try {
      final response = await client.currency.convertCurrency(
        _fromCurrency,
        _toCurrency,
        amount,
      );

      setState(() {
        _toAmountController.text = response.convertedAmount.toStringAsFixed(2);
        _exchangeRate = response.exchangeRate;
        _lastUpdateTime = response.timestamp;
        _isConverting = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Conversion failed: $e';
        _isConverting = false;
      });
    }
  }

  Future<void> _getExchangeRate() async {
    if (_fromCurrency == _toCurrency) {
      setState(() {
        _exchangeRate = 1.0;
      });
      return;
    }

    try {
      final response = await client.currency.getExchangeRate(
        _fromCurrency,
        _toCurrency,
      );

      setState(() {
        _exchangeRate = response.rate;
        _lastUpdateTime = response.timestamp;
      });
    } catch (e) {
      // Silently fail for exchange rate
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      
      final tempAmount = _fromAmountController.text;
      _fromAmountController.text = _toAmountController.text;
      _toAmountController.text = tempAmount;
    });
    
    _convertCurrency();
    _getExchangeRate();
  }

  String _getCurrencySymbol(String currency) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
      'MXN': '\$',
      'KRW': '₩',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NZD': 'NZ\$',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'TRY': '₺',
      'RUB': '₽',
      'ZAR': 'R',
      'AED': 'د.إ',
      'SAR': '﷼',
    };
    return symbols[currency] ?? currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          maxWidth: 800,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.horizontalPadding,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section - Currency Converter
                _buildHeroSection(),
                
                const SizedBox(height: 32),
                
                // Exchange Rate Info
                if (_exchangeRate != null) _buildExchangeRateInfo(),
                
                const SizedBox(height: 24),
                
                // Error Message
                if (_error != null) _buildErrorCard(),
                
                const SizedBox(height: 24),
                
                // Info Section
                _buildInfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // From Currency (Left)
          _buildCurrencyInput(
            controller: _fromAmountController,
            currency: _fromCurrency,
            label: 'From',
            isFrom: true,
          ),
          
          const SizedBox(height: 16),
          
          // Swap Button
          _buildSwapButton(),
          
          const SizedBox(height: 16),
          
          // To Currency (Right)
          _buildCurrencyInput(
            controller: _toAmountController,
            currency: _toCurrency,
            label: 'To',
            isFrom: false,
            isLoading: _isConverting,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyInput({
    required TextEditingController controller,
    required String currency,
    required String label,
    required bool isFrom,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Currency Dropdown
            _buildCurrencyDropdown(
              value: currency,
              onChanged: (newCurrency) {
                setState(() {
                  if (isFrom) {
                    _fromCurrency = newCurrency!;
                  } else {
                    _toCurrency = newCurrency!;
                  }
                });
                _convertCurrency();
                _getExchangeRate();
              },
            ),
            const SizedBox(width: 12),
            
            // Amount Input
            Expanded(
              child: TextField(
                controller: controller,
                enabled: isFrom && !isLoading,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300],
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            
            // Loading Indicator
            if (isLoading && !isFrom)
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    // Ensure the value exists in the list, otherwise use first currency
    final validValue = _availableCurrencies.contains(value) 
        ? value 
        : (_availableCurrencies.isNotEmpty ? _availableCurrencies.first : null);
    
    // Remove duplicates and ensure unique values
    final uniqueCurrencies = _availableCurrencies.toSet().toList()..sort();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButton<String>(
        value: validValue,
        onChanged: _isLoadingCurrencies ? null : onChanged,
        underline: const SizedBox(),
        icon: Icon(
          LucideIcons.chevronDown,
          size: 18,
          color: Colors.grey[600],
        ),
        items: uniqueCurrencies.map((currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getCurrencySymbol(currency),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currency,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwapButton() {
    return Center(
      child: GestureDetector(
        onTap: _swapCurrencies,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!, width: 1.5),
          ),
          child: Icon(
            LucideIcons.arrowUpDown,
            size: 20,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildExchangeRateInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.trendingUp,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1 $_fromCurrency = ${_exchangeRate!.toStringAsFixed(4)} $_toCurrency',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_lastUpdateTime != null)
                  Text(
                    'Updated ${_formatTime(_lastUpdateTime!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.triangleAlert,
            color: Colors.red[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.info,
                size: 18,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              const Text(
                'About Currency Converter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Real-time exchange rates are fetched from ExchangeRate-API.com. '
            'Rates are updated frequently and cached for optimal performance.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
