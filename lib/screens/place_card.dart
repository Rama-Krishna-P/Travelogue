import 'package:flutter/material.dart';
import 'package:travelogue/models/model.dart';

class PlaceCard extends StatelessWidget {
  final Place _place;

  PlaceCard(this._place);

  @override
  Widget build(BuildContext context) {
    String startDate = this._place.startDate;
    String stopDate = this._place.stopDate;
    String latitude = this._place.latitude.toString();
    String longitude = this._place.longitude.toString();

    debugPrint(this._place.type);
    return Card(
      elevation: 5.0,
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  _place.name,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Divider(
                height: 10,
                color: Colors.black,
              ),
              _place.type == 'Marker Place' ||
                      _place.type == 'Stop Place' ||
                      (_place.type == 'Intermediate Place' && stopDate != null)
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.5, bottom: 5.0),
                      child: Text('Stop Date: $stopDate'),
                    )
                  : Container(),
              _place.type == 'Start Place' ||
                      _place.type == 'Marker Place' ||
                      _place.type == 'Intermediate Place'
                  ? Padding(
                      padding: EdgeInsets.only(top: 2.5, bottom: 5.0),
                      child: Text('Start Date: $startDate'),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 2.5, bottom: 5.0),
                child: Text('Latitude: $latitude'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5, bottom: 5.0),
                child: Text('Longitude: $longitude'),
              ),
              Container(
                height: 2.5,
              )
          ],
      ) /*Text(
          _place.name,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text('test'),*/
          ),
    );
  }
}
