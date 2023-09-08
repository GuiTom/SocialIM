import 'package:base/base.dart';
import 'package:flutter/material.dart';
import '../locale/k.dart';

class AreaSettingWidget extends StatefulWidget {
  static Future<Map<String, String>?> showFromModalBottomSheet(
      BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const AreaSettingWidget();
        });
  }

  const AreaSettingWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State {
  String? _country;
  String? _state;
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            K.getTranslation('select_your_area'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 30,
          ),
          _buildAreaPickerWidget(),
          const SizedBox(
            height: 30,
          ),
          _buildConfirmButton(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildAreaPickerWidget() {
    return CSCPicker(
      ///Enable disable state dropdown [OPTIONAL PARAMETER]
      showStates: true,

      /// Enable disable city drop down [OPTIONAL PARAMETER]
      showCities: true,

      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
      flagState: CountryFlag.ENABLE,

      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
      dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1)),

      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
      disabledDropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade300, width: 1)),

      ///placeholders for dropdown search field
      countrySearchPlaceholder: K.getTranslation('country'),
      stateSearchPlaceholder: K.getTranslation('state'),
      citySearchPlaceholder: K.getTranslation('city'),

      ///labels for dropdown
      countryDropdownLabel: K.getTranslation('country'),
      stateDropdownLabel: K.getTranslation('state'),
      cityDropdownLabel: K.getTranslation('city'),

      ///Default Country
      ///defaultCountry: CscCountry.India,
      ///Country Filter [OPTIONAL PARAMETER]
      countryFilter: const [
        CscCountry.China,
        CscCountry.India,
        CscCountry.United_States,
        CscCountry.Canada
      ],

      ///Disable country dropdown (Note: use it with default country)
      //disableCountry: true,
      ///selected item style [OPTIONAL PARAMETER]
      selectedItemStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
      dropdownHeadingStyle: const TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),

      ///DropdownDialog Item style [OPTIONAL PARAMETER]
      dropdownItemStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      ///Dialog box radius [OPTIONAL PARAMETER]
      dropdownDialogRadius: 10.0,

      ///Search bar radius [OPTIONAL PARAMETER]
      searchBarRadius: 10.0,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        _country = value;
        setState(() {
          ///store value in country variable
        });
      },

      ///triggers once state selected in dropdown
      onStateChanged: (value) {
        _state = value;
        setState(() {
          ///store value in state variable
        });
      },

      ///triggers once city selected in dropdown
      onCityChanged: (value) {
        _city = value;
        setState(() {});
      },

      ///Show only specific countries using country filter
      // countryFilter: ["United States", "Canada", "Mexico"],
    );
  }

  Widget _buildConfirmButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(
            context, _country!=null?{'country': _country??'', 'state': _state??'', 'city': _city??''}:null);
      },
      child: Button(
        title: K.getTranslation('confirm'),
        buttonSize: ButtonSize.Big,
      ),
    );
  }
}
