import 'package:biden_blast/team.dart';
import 'package:biden_blast/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Validation callback for team number.
String? _validateNumber(String? value) {
  final isInvalidNumber = value == null || value.length > 5 || int.tryParse(value) == null;
  if (isInvalidNumber) {
    return 'Invalid ID';
  } else {
    return null;
  }
}

class NewTeamPage extends StatefulWidget {
  final Function(int)? onTeamCreated;
  const NewTeamPage({super.key, this.onTeamCreated});

  @override
  State<NewTeamPage> createState() => _NewTeamPageState();
}

class _NewTeamPageState extends State<NewTeamPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _name = "";

  /// Validate the form and, if valid, add a new team and swap to it.
  void _formSubmit(BuildContext context) {
    var formState = _formKey.currentState!;
    if (formState.validate()) {
      formState.save();

      if (!Provider.of<TeamsModel>(context, listen: false).add(Team(id: _id, name: _name), context)) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team \'$_name\' ($_id) added.')),
      );
      formState.reset();
      widget.onTeamCreated?.call(_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Team ID', border: OutlineInputBorder()),
                validator: _validateNumber,
                keyboardType: TextInputType.number,
                onSaved: (String? val) {_id = int.parse(val!);},
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Team Name', 
                  border: OutlineInputBorder(),
                ),
                validator: (String? val) => (val == null || val.isEmpty) ? 'Please enter a team name.' : null,
                onSaved: (String? val) {_name = val!;},
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                label: const Text('Add'),
                icon: const Icon(Icons.add),
                onPressed: () => _formSubmit(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
