import 'package:flutter/material.dart';
import 'package:travelogue/models/model.dart';

import 'place_card.dart';

class SingleDayPlaces extends StatelessWidget {
  final List<Place> _places;
  final String _date;

  SingleDayPlaces(this._places, this._date);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 218, 218,
              218) // Colors.green, //Color.fromARGB(0, 237, 238, 240),
      ),
      child: Column(
        children: <Widget>[
          Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text('$_date',
                    style: Theme.of(context).textTheme.headline),
              )),
          Expanded(
            child: Center(
              child: getListView(),
            ),
          )
        ],
      )
    );
  }

  getListView() {
    return ListView.builder(
      itemCount: this._places.length,
      //padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      itemBuilder: (BuildContext context, int position) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
          child: PlaceCard(this._places[position]),
        );
      },
    );
  }
}
