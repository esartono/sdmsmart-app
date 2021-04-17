import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Network {
  userData(data) async {
    String url = 'https://fire.nurulfikri.sch.id/api/v1/user';

    return await apiRequest(url, data);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
}
