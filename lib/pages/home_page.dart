import 'package:flutter/material.dart';
import 'package:final_fifa/models/team_item.dart';
import 'package:final_fifa/pages/result.dart';
import 'package:final_fifa/services/api.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  static const apiBaseUrl = 'http://103.74.252.66:8888';
  List<TeamItem>? _list;
  var _isLoading = false;
  String? _errMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Image(
                    image: AssetImage("assets/images/logo.jpg"),
                    width: double.infinity,
                    height: 100.0,
                  )),
            ),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Result.routeName,);
                  },
                  child: const Text('View Result'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await Api().fetch();
      setState(() {
        _list = data.map<TeamItem>((item) => TeamItem.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _Vote(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await Api().vote(index);
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    var TeamItem = _list![index];

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(3.0),
      shadowColor: Colors.black.withOpacity(1),
      child: InkWell(
        onTap: () {},
        child: Padding(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TeamItem.team),
                        const SizedBox(width: 10.0),
                        Text("Group : " + TeamItem.group),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                ),
                onPressed: () {
                  _Vote(index+1);
                },
                child: const Text('Vote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
