import 'dart:convert';
import 'dart:io';
import 'base_integration.dart';

/// OpenAI API integration for AI-powered features
///
/// Provides integration with OpenAI API for chat completions, embeddings,
/// image generation, and other AI capabilities.
///
/// Usage:
/// 1. Get an API key from https://platform.openai.com/api-keys
/// 2. Configure in YAML with apiKey
/// 3. Optionally set organizationId and baseUrl (for custom endpoints)
///
/// Supported features:
/// - Chat completions (GPT models)
/// - Text embeddings
/// - Image generation (DALL-E)
/// - Audio transcription
/// - Fine-tuning management
class OpenAIIntegration extends BaseIntegration {
  final bool _enabled;
  final String? _apiKey;
  final String? _organizationId;
  final String? _baseUrl;
  final String? _defaultModel;
  final Map<String, dynamic> _config;

  /// Base URL for OpenAI API
  static const String _defaultBaseUrl = 'https://api.openai.com/v1';

  /// HTTP client for API calls
  HttpClient? _httpClient;

  OpenAIIntegration({
    required bool enabled,
    String? apiKey,
    String? organizationId,
    String? baseUrl,
    String? defaultModel,
    Map<String, dynamic>? additionalConfig,
  })  : _enabled = enabled,
        _apiKey = apiKey,
        _organizationId = organizationId,
        _baseUrl = baseUrl ?? _defaultBaseUrl,
        _defaultModel = defaultModel ?? 'gpt-3.5-turbo',
        _config = additionalConfig ?? {};

  @override
  bool get enabled => _enabled;

  @override
  String get name => 'openai';

  /// Get the base URL being used
  String get baseUrl => _baseUrl ?? _defaultBaseUrl;

  /// Get the default model
  String get defaultModel => _defaultModel ?? 'gpt-3.5-turbo';

  @override
  Map<String, dynamic> getConfig() {
    return {
      'enabled': _enabled,
      'hasApiKey': _apiKey != null && _apiKey.isNotEmpty,
      'hasOrganizationId': _organizationId != null && _organizationId.isNotEmpty,
      'baseUrl': _baseUrl,
      'defaultModel': _defaultModel,
      ..._config,
    };
  }

  @override
  Future<void> initialize() async {
    if (!_enabled) {
      return;
    }

    if (_apiKey == null || _apiKey.isEmpty) {
      throw Exception('OpenAI API key is required when OpenAI integration is enabled');
    }

    // Initialize HTTP client
    _httpClient = HttpClient();

    // Verify credentials by checking models endpoint
    try {
      final healthy = await isHealthy();
      if (!healthy) {
        throw Exception('Failed to connect to OpenAI API');
      }
    } catch (e) {
      throw Exception('Failed to initialize OpenAI integration: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _httpClient?.close();
    _httpClient = null;
  }

  @override
  Future<bool> isHealthy() async {
    if (!_enabled) {
      return true;
    }

    try {
      // Check if we can list models (lightweight health check)
      final response = await _get('/models');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // HTTP HELPERS
  // ============================================================

  /// Common headers for all requests
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    if (_organizationId != null && _organizationId.isNotEmpty) {
      headers['OpenAI-Organization'] = _organizationId;
    }

    return headers;
  }

  /// GET request
  Future<HttpClientResponse> _get(String endpoint) async {
    if (_httpClient == null) {
      throw Exception('OpenAI integration not initialized');
    }

    final uri = Uri.parse('$baseUrl$endpoint');
    final request = await _httpClient!.getUrl(uri);
    
    _headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    return await request.close();
  }

  /// POST request
  Future<HttpClientResponse> _post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    if (_httpClient == null) {
      throw Exception('OpenAI integration not initialized');
    }

    final uri = Uri.parse('$baseUrl$endpoint');
    final request = await _httpClient!.postUrl(uri);
    
    _headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    if (body != null) {
      request.write(jsonEncode(body));
    }

    return await request.close();
  }

  /// Parse JSON response
  Future<Map<String, dynamic>> _parseResponse(HttpClientResponse response) async {
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(responseBody) as Map<String, dynamic>;
    }

    // Try to parse error message
    String errorMessage = 'Unknown error';
    try {
      final errorData = jsonDecode(responseBody) as Map<String, dynamic>;
      errorMessage = errorData['error']?['message'] as String? ?? 
                     errorData['error']?.toString() ?? 
                     responseBody;
    } catch (e) {
      errorMessage = responseBody;
    }

    throw OpenAIApiException(
      statusCode: response.statusCode,
      message: errorMessage,
    );
  }

  // ============================================================
  // CHAT COMPLETIONS
  // ============================================================

  /// Create a chat completion
  ///
  /// [messages] - List of message objects with 'role' and 'content'
  /// [model] - Model to use (defaults to configured defaultModel)
  /// [temperature] - Sampling temperature (0-2)
  /// [maxTokens] - Maximum tokens to generate
  /// [stream] - Whether to stream the response
  ///
  /// Returns the completion response
  Future<Map<String, dynamic>> createChatCompletion({
    required List<Map<String, dynamic>> messages,
    String? model,
    double? temperature,
    int? maxTokens,
    bool stream = false,
    Map<String, dynamic>? additionalParams,
  }) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final body = <String, dynamic>{
      'model': model ?? _defaultModel,
      'messages': messages,
      if (temperature != null) 'temperature': temperature,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (stream) 'stream': stream,
      ...?additionalParams,
    };

    final response = await _post('/chat/completions', body: body);
    return await _parseResponse(response);
  }

  /// Create a simple text completion (convenience method)
  ///
  /// [prompt] - The prompt text
  /// [systemMessage] - Optional system message
  /// [model] - Model to use
  /// [temperature] - Sampling temperature
  ///
  /// Returns the completion text
  Future<String> completeText({
    required String prompt,
    String? systemMessage,
    String? model,
    double? temperature,
  }) async {
    final messages = <Map<String, dynamic>>[];
    
    if (systemMessage != null) {
      messages.add({
        'role': 'system',
        'content': systemMessage,
      });
    }
    
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    final response = await createChatCompletion(
      messages: messages,
      model: model,
      temperature: temperature,
    );

    final choices = response['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw OpenAIApiException(
        statusCode: 200,
        message: 'No completion choices returned',
      );
    }

    final firstChoice = choices[0] as Map<String, dynamic>;
    final message = firstChoice['message'] as Map<String, dynamic>?;
    return message?['content'] as String? ?? '';
  }

  // ============================================================
  // EMBEDDINGS
  // ============================================================

  /// Create embeddings for input text
  ///
  /// [input] - Text or list of texts to embed
  /// [model] - Embedding model (defaults to 'text-embedding-ada-002')
  ///
  /// Returns embeddings response
  Future<Map<String, dynamic>> createEmbedding({
    required dynamic input,
    String? model,
  }) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final body = <String, dynamic>{
      'model': model ?? 'text-embedding-ada-002',
      'input': input,
    };

    final response = await _post('/embeddings', body: body);
    return await _parseResponse(response);
  }

  /// Get embedding vector for a single text
  ///
  /// [text] - Text to embed
  /// [model] - Embedding model
  ///
  /// Returns the embedding vector as List<double>
  Future<List<double>> getEmbedding({
    required String text,
    String? model,
  }) async {
    final response = await createEmbedding(input: text, model: model);
    final data = response['data'] as List?;
    
    if (data == null || data.isEmpty) {
      throw OpenAIApiException(
        statusCode: 200,
        message: 'No embedding data returned',
      );
    }

    final embedding = data[0] as Map<String, dynamic>;
    final embeddingList = embedding['embedding'] as List?;
    
    if (embeddingList == null) {
      throw OpenAIApiException(
        statusCode: 200,
        message: 'Invalid embedding format',
      );
    }

    return embeddingList.cast<double>();
  }

  // ============================================================
  // IMAGE GENERATION
  // ============================================================

  /// Generate an image using DALL-E
  ///
  /// [prompt] - Text description of the image
  /// [n] - Number of images to generate (1-10)
  /// [size] - Image size ('256x256', '512x512', or '1024x1024')
  /// [responseFormat] - Response format ('url' or 'b64_json')
  ///
  /// Returns image generation response
  Future<Map<String, dynamic>> createImage({
    required String prompt,
    int n = 1,
    String size = '1024x1024',
    String responseFormat = 'url',
  }) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final body = <String, dynamic>{
      'prompt': prompt,
      'n': n,
      'size': size,
      'response_format': responseFormat,
    };

    final response = await _post('/images/generations', body: body);
    return await _parseResponse(response);
  }

  /// Generate image and return URL
  ///
  /// [prompt] - Text description of the image
  /// [size] - Image size
  ///
  /// Returns the image URL
  Future<String> generateImageUrl({
    required String prompt,
    String size = '1024x1024',
  }) async {
    final response = await createImage(
      prompt: prompt,
      size: size,
      responseFormat: 'url',
    );

    final data = response['data'] as List?;
    if (data == null || data.isEmpty) {
      throw OpenAIApiException(
        statusCode: 200,
        message: 'No image data returned',
      );
    }

    final imageData = data[0] as Map<String, dynamic>;
    return imageData['url'] as String? ?? '';
  }

  // ============================================================
  // AUDIO TRANSCRIPTION
  // ============================================================

  /// Transcribe audio to text
  ///
  /// [file] - Audio file bytes
  /// [fileName] - Name of the audio file
  /// [model] - Model to use (defaults to 'whisper-1')
  /// [language] - Language code (optional)
  /// [prompt] - Optional text to guide the model
  ///
  /// Returns transcription response
  Future<Map<String, dynamic>> createTranscription({
    required List<int> file,
    required String fileName,
    String model = 'whisper-1',
    String? language,
    String? prompt,
  }) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    // Note: This is a simplified implementation
    // For multipart/form-data uploads, you may need to use a different approach
    // or a package that handles multipart requests better
    
    throw UnimplementedError(
      'Audio transcription requires multipart/form-data upload. '
      'Consider using a package like http or dio for better multipart support.',
    );
  }

  // ============================================================
  // MODELS MANAGEMENT
  // ============================================================

  /// List all available models
  ///
  /// Returns list of models
  Future<List<Map<String, dynamic>>> listModels() async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final response = await _get('/models');
    final data = await _parseResponse(response);
    final models = data['data'] as List?;
    
    return models?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get a specific model
  ///
  /// [modelId] - Model identifier
  ///
  /// Returns model information
  Future<Map<String, dynamic>> getModel(String modelId) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final response = await _get('/models/$modelId');
    return await _parseResponse(response);
  }

  // ============================================================
  // FINE-TUNING (Basic support)
  // ============================================================

  /// List fine-tuning jobs
  ///
  /// Returns list of fine-tuning jobs
  Future<List<Map<String, dynamic>>> listFineTuningJobs() async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final response = await _get('/fine_tuning/jobs');
    final data = await _parseResponse(response);
    final jobs = data['data'] as List?;
    
    return jobs?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get a specific fine-tuning job
  ///
  /// [jobId] - Fine-tuning job ID
  ///
  /// Returns job information
  Future<Map<String, dynamic>> getFineTuningJob(String jobId) async {
    if (!_enabled) {
      throw Exception('OpenAI integration is not enabled');
    }

    final response = await _get('/fine_tuning/jobs/$jobId');
    return await _parseResponse(response);
  }
}

/// Custom exception for OpenAI API errors
class OpenAIApiException implements Exception {
  final int statusCode;
  final String message;

  OpenAIApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'OpenAIApiException($statusCode): $message';
}
