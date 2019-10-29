import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/models/model.dart';

import 'place_edit.dart';
import 'single_day_places.dart';

class PlaceList extends StatefulWidget {
  final Map<String, List<Place>> _places;

  final int _tripId;

  PlaceList(this._tripId, this._places);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlaceListState(this._tripId, this._places);
  }
}

class PlaceListState extends State<PlaceList> {
  Map<String, List<Place>> _places;
  List<String> _dates;
  String _today;
  int _startPageNo;
  bool _floatButtonVisible;
  final int _tripId;

  PlaceListState(this._tripId, this._places){
    this._today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    this._dates = this._places.keys.toList();
    this._startPageNo = this._dates.indexOf(this._today);

    if (this._startPageNo < 0) {
      this._startPageNo = 0;
      this._floatButtonVisible = false;
    }
    else {
      this._floatButtonVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Travelogue",
          textScaleFactor: 1.25,
        )),
        body: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 218, 218, 218)),
          child: CarouselSlider(
            initialPage: this._startPageNo,
            height: MediaQuery.of(context).size.height,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: onViewChanged,
            items: this._places.entries.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return SingleDayPlaces(i.value, i.key);
                },
              );
            }).toList(),
          ),
        ),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  onViewChanged(int pageNo) {
    setState(() {
      this._startPageNo = pageNo;
      _floatButtonVisible = _dates[pageNo] == _today;
    });
  }
  
  getFloatingActionButton() {
    return _floatButtonVisible ? FloatingActionButton(
      onPressed: () {
        //navigateToDetail(Trip(), 'Add Trip');
        navigateToEdit(Place(), 'Add Place');
      },
      child: Icon(Icons.add),
    )
    : null;
  }

  navigateToEdit(Place place, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlaceEdit(_tripId, place, title);
    }));

    if (result) {
      refreshPlaces();
    }
  }

  void refreshPlaces() async {
    String currentDate = this._dates[this._startPageNo];

    List<Place> places = await Place().select().dateCreated.equals(currentDate).toList();

    setState(() {
      this._places[currentDate] = places;
    });
  }
}