import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/models/model.dart';

import 'place_list.dart';
import 'trip_detail.dart';

class TripList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TripListState();
  }
}

class TripListState extends State<TripList> {
  List<Trip> _trips;
  int _count = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._trips == null) {
      this.refreshTrips();
    }


    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              "Travelogue",
              textScaleFactor: 1.25,
            ),
          )),
      body: getTripsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Trip(), 'Add Trip');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getTripsList() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    //debugPrint('get trips list');

    return ListView.builder(
        itemCount: _count,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Card(
              elevation: 5.0,
              child: ListTile(
                title: Text(
                  this._trips[position].name,
                  style: titleStyle,
                  textScaleFactor: 1.25,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'from ${this._trips[position].fromDate} to ${this._trips[position].toDate}',
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        editTrip(this._trips[position]);
                      },
                    ),
                    Container(
                      width: 10.0,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                onTap: () {
                  this.openTrip(this._trips[position]);
                },
              ),
            ),
          );
        });
  }

  void navigateToDetail(Trip trip, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TripDetail(trip, title);
    }));

    //if (result) {
    refreshTrips();
    //}
  }

  void refreshTrips() async {
    List<Trip> trips = await Trip().select().toList();

    setState(() {
      this._trips = trips;
      this._count = this._trips.length;
      //debugPrint("Trips count: " + this._trips.length.toString());
    });
  }

  editTrip(Trip trip) {
    navigateToDetail(trip, 'Edit Trip');
  }

  void openTrip(Trip trip) async {
    /*await Place(name: 'Place 1', startDate: '2019-10-23 10:35:00', stopDate: '2019-10-23 10:25:00', dateCreated: '2019-10-23', tripId: trip.id, type: 'Intermediate Place').save();
    await Place(name: 'Place 2', startDate: '2019-10-23 11:35:00', stopDate: '2019-10-23 11:25:00', dateCreated: '2019-10-23', tripId: trip.id, type: 'Intermediate Place').save();
    await Place(name: 'Place 3', startDate: '2019-10-24 11:35:00', stopDate: '2019-10-24 11:25:00', dateCreated: '2019-10-24', tripId: trip.id, type: 'Intermediate Place').save();*/

    var placeList = await Place().select().tripId.equals(trip.id).toList();

    Map<String, List<Place>> dateGroupedPlaces = Map();

    for (int i = 0; i < placeList.length; i++) {
      String key = placeList[i].dateCreated;
      if (!dateGroupedPlaces.containsKey(key)) {
        dateGroupedPlaces[key] = new List<Place>();
      }

      dateGroupedPlaces[key].add(placeList[i]);
    }

    checkIfTodayShouldBeAdded(trip, dateGroupedPlaces);

    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlaceList(trip.id, dateGroupedPlaces);
    }));
  }

  void checkIfTodayShouldBeAdded(
      Trip trip, Map<String, List<Place>> dateGroupedPlaces) {
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (!dateGroupedPlaces.containsKey(today) &&
        today.compareTo(trip.fromDate) >= 0 &&
        today.compareTo(trip.toDate) <= 0) {
      dateGroupedPlaces[today] = new List<Place>();
    }
  }
}
