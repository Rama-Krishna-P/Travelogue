import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/models/model.dart';

class TripDetail extends StatefulWidget {

  final Trip trip;
  final String title;

  TripDetail(this.trip, this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TripDetailState(this.trip, this.title);
  }

}

class TripDetailState extends State<TripDetail> {

  //static var _placeTypes = ['Start Place', 'Intermediate Place', 'Marker Place', 'Stop Place'];
  TextEditingController nameController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  final Trip trip;
  final String title;

  TripDetailState(this.trip, this.title);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    nameController.text = trip.name;
    fromDateController.text = toDisplayFormat(trip.fromDate);
    toDateController.text = toDisplayFormat(trip.toDate);

    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        moveToLastScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            title:  Text(this.title,
              textScaleFactor: 1.25,),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding:  EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      this.trip.name = value;
                      debugPrint(this.trip.name);
                    },
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                  child: DateTimeField(
                    controller: fromDateController,
                    onChanged: (value) {
                      if (value != null) {
                        this.trip.fromDate =  dateFormat.format(value);
                        debugPrint(this.trip.fromDate);
                      }
                    },
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    decoration: InputDecoration(
                        labelText: "From Date",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                  child: DateTimeField(
                    controller: toDateController,
                    onChanged: (value) {
                      if (value != null) {
                        this.trip.toDate = dateFormat.format(value);
                        debugPrint(this.trip.toDate);
                      }
                    },
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    decoration: InputDecoration(
                        labelText: "To Date",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            this.saveTrip(context);
                          },
                        ),
                      ),
                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                /*Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
              child: DropdownButton(
                isExpanded: true,
                items: _placeTypes.map((String dropDownStringItem) {
                  return DropdownMenuItem<String> (
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),

                style: textStyle,

                value: 'Start Place',

                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint('User selected $valueSelectedByUser');
                  });
                },
              )
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
              child: Text("Latitude: 12.07", textScaleFactor: 1.5,),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
              child: Text("Longitude: 15.07", textScaleFactor: 1.5,),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
              child: Text("Accuracy: 3", textScaleFactor: 1.5,),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Save button clicked");
                        });
                      },
                    ),
                  ),
                  Container(width: 5.0,),

                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),*/

              ],
            ),
          )
      ),
    );
  }

  void saveTrip(BuildContext context) async {
    //try {
    int success = await this.trip.save();
    //}
    //finally {
    moveToLastScreen();
    //}
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  String toDisplayFormat(String value) {
    if (value != null) {
      DateFormat storedFormat = DateFormat("yyyy-MM-dd");
      DateTime dateValue = storedFormat.parse(value);


      DateFormat displayFormat = DateFormat("dd-MM-yyyy");
      return displayFormat.format(dateValue);
    }
    else {
      return '';
    }
  }
}