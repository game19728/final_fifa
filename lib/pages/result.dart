import 'package:flutter/material.dart';
import 'package:final_fifa/models/team_item.dart';
import 'package:final_fifa/services/api.dart';

class Result extends StatefulWidget {
  static const routeName = '/result';

  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  static const apiBaseUrl = 'http://103.74.252.66:8888';
  List<TeamItem>? _list;
  var _isLoading = false;
  String? _errMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VOTE RESULT"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_list != null)
                    ListView.builder(
                      itemBuilder: _buildListItem,
                      itemCount: _list!.length,
                    ),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_errMessage != null && !_isLoading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(_errMessage!),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _fetchData();
                            },
                            child: const Text('RETRY'),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchData() async {
    try {
      var data = await Api().fetchVote();
      setState(() {
        _list = data.map<TeamItem>((item) => TeamItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
      });
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    var TeamItem = _list![index];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Image.network(
                  apiBaseUrl + TeamItem.flagImage,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8.0),
                Text(TeamItem.team, style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          Text('${TeamItem.voteCount}', style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}
