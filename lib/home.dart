import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List _lista = [];

  final _controller = TextEditingController();

  Future _getData(context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String save = _prefs.getString("lista");
    if(save == null){
      _lista = [];
    } else {
      setState(() {
        _lista = jsonDecode(save);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900]              
      ),
      body: ListView.builder(
        itemCount: _lista.length,
        itemBuilder: _listaBuilder,        
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).scaffoldBackgroundColor),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: _floatingButton,
      ),
    );
  }

  Widget _listaBuilder(context, index){
    return CheckboxListTile(
      title: Text(_lista[index]["nome"], style: TextStyle(color: Theme.of(context).appBarTheme.color),),
      value: _lista[index]["status"],
      checkColor: Theme.of(context).scaffoldBackgroundColor,
      secondary: IconButton(
        icon: Icon(
          Icons.delete_outline,
          color: Theme.of(context).appBarTheme.iconTheme.color,
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              elevation: 15,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text("Atenção", style: TextStyle(color: Theme.of(context).accentColor)),
              content: Text("Realmente deseja apagar este item?", style: TextStyle(color: Theme.of(context).accentColor)),
              actions: [
                FlatButton(
                  child: Text("Cancelar", style: TextStyle(color: Theme.of(context).accentColor)),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Confirmar", style: TextStyle(color: Theme.of(context).accentColor)),
                  onPressed: () async {
                    _lista.removeAt(index);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("lista", jsonEncode(_lista));
                    Navigator.pop(context);
                    setState(() {
                    });
                  },
                )
              ],
            )    
          );
        },
      ),
      onChanged: (val) async {
        _lista[index]["status"] = val;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("lista", jsonEncode(_lista));

        setState(() {
        });
      },
    );
  }

  void _floatingButton() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context){
        return Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).accentColor, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                style: TextStyle(color: Theme.of(context).accentColor),
                decoration: InputDecoration(
                  labelText: "Nova Tarefa",
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              RaisedButton(
                child: Text("Adicionar", style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  _lista.add(
                    {
                      "nome" : _controller.text,
                      "status" : false
                    }
                  );
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("lista", jsonEncode(_lista));
                  setState(() {
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          )
        );
      }
    );
    _controller.text = "";
  }
}