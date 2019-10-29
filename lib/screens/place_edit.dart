import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/models/model.dart';
import 'package:location/location.dart';

class PlaceEdit extends StatefulWidget {
  final Place _place;
  final String _title;
  final int _tripId;

  PlaceEdit(this._tripId, this._place, this._title);

  @override
  _PlaceEditState createState() =>
      _PlaceEditState(this._tripId, this._place, this._title);
}

class _PlaceEditState extends State<PlaceEdit> {
  final _placeTypes = [
    "Intermediate Place",
    "Marker Place",
    "Start Place",
    "Stop Place"
  ];
  final Place _place;
  final String _title;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _latitudeController = new TextEditingController();
  final TextEditingController _longitudeController =
      new TextEditingController();
  final TextEditingController _accuracyController = new TextEditingController();
  bool _fetchingCoOrdinates;

  TextStyle _textStyle;

  final int _tripId;

  _PlaceEditState(this._tripId, this._place, this._title) {
    this._fetchingCoOrdinates = this._place.id == null;
    this._nameController.text = this._place.name;

    if (_place.type == null) {
      this._place.type = 'Start Place';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    this._textStyle = Theme.of(context).textTheme.title;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                navigateBack();
              }),
        ),
        body: this._fetchingCoOrdinates
            ? getProgressIndicator()
            : getNewPlaceForm(),
      ),
      onWillPop: () {
        navigateBack();
      },
    );
  }

  navigateBack() {
    Navigator.pop(context, true);
  }

  getNewPlaceForm() {
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            child: getPlaceTypesDropDown(),
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
          ),
          Padding(
            child: getPlaceNameField(),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          ),
          Padding(
            child: getDisabledFields(_latitudeController, "Latitude"),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          ),
          Padding(
            child: getDisabledFields(_longitudeController, "Longitude"),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Theme.of(context).primaryColorLight,
              child: Text(
                'Save',
                textScaleFactor: 1.5,
              ),
              onPressed: savePlace,
            ),
          ),
        ],
      ),
    );
  }

  getPlaceNameField() {
    return TextField(
      controller: _nameController,
      style: _textStyle,
      onChanged: (value) {
        this._place.name = value;
      },
      decoration: InputDecoration(
          labelText: "Name",
          labelStyle: _textStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getDisabledFields(TextEditingController textEditingController, String label) {
    return TextField(
      controller: textEditingController,
      enabled: false,
      style: _textStyle,
      onChanged: (value) {
        this._place.name = value;
      },
      decoration: InputDecoration(
          labelText: label,
          labelStyle: _textStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getPlaceTypesDropDown() {
    return DropdownButton(
      items: _placeTypes.map((String placeType) {
        return DropdownMenuItem<String>(
          value: placeType,
          child: Text(placeType),
        );
      }).toList(),
      value: _place.type == null ? "Start Place" : _place.type,
      onChanged: (valueSelectedByUser) {
        setState(() {
          this._place.type = valueSelectedByUser;
        });
      },
    );
  }

  getProgressIndicator() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Fetching co-ordinates",
          style: _textStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: CircularProgressIndicator(),
        ),
      ],
    ));
  }

  void getCurrentLocation() async {
    Location location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    var currentLocation = await location.getLocation();
    this._place.latitude = currentLocation['latitude'];
    this._place.longitude = currentLocation['longitude'];

    _latitudeController.text = this._place.latitude.toString();
    _longitudeController.text = this._place.longitude.toString();

    setState(() {
      this._fetchingCoOrdinates = false;
    });
  }

  void savePlace() {
    this._place.tripId = this._tripId;
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    this._place.dateCreated = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (this._place.type == "Start Place") {
      this._place.startDate = format.format(DateTime.now());
    } else if (this._place.type == "Intermediate Place") {
      this._place.startDate = format.format(DateTime.now());
    } else if (this._place.type == "Marker Place") {
      this._place.startDate = format.format(DateTime.now());
      this._place.stopDate = format.format(DateTime.now());
    } else if (this._place.type == "Stop Place") {
      this._place.stopDate = format.format(DateTime.now());
    }

    this._place.save();
    this.navigateBack();
  }
}
