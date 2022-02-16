// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightspeed_voice_task/data/user_repository.dart';
import 'package:lightspeed_voice_task/pages/todos_page.dart';
import 'package:lightspeed_voice_task/user_bloc/users_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home:BlocProvider(
          create: (context) => UsersBloc(UserRepository()),
        child: const UsersPage(),
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({Key key}) : super(key: key);


  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String userName;
  int _widgetIndex = 0;
  Future futureForUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062F06), //FF062F06
      body: Center(
        child: FutureBuilder(
            future: futureForUsers,
            builder: (context, snapshot) {
              if(snapshot.hasData == false) {
                final userBloc = context.bloc<UsersBloc>();
                userBloc.add(GetUsers());
                return usersContainer();
              } else {
                return usersLoaded(futureForUsers);
              }
            }
        )
      ),



    );
  }

  Widget usersContainer() {
    /*final userBloc = context.bloc<UsersBloc>();
    userBloc.add(GetUsers());*/


    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
    if (state is UsersError) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
      },
      builder: (context, state) {
    if (state is UsersInitial) {
      return Container(color: Colors.grey,);
    } else if (state is Loading) {
      return CircularProgressIndicator();
    } else if (state is UsersLoaded) {
      futureForUsers = state.userFuture;
      return usersLoaded(state.userFuture);
    } else {
      return Container(height: 150,padding: const EdgeInsets.all(20),decoration: const BoxDecoration(color: Color(
          0xFF157815),borderRadius: BorderRadius.all(Radius.circular(20))),child: Column(
            children: [
              Text('There was a problem fetching the data. Is your device online?',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
              Icon(Icons.error_outline,color: Color(0xFF920000),),
              ElevatedButton(onPressed: (){
                final userBloc = context.bloc<UsersBloc>();
                userBloc.add(GetUsers());
              }, child: Text("Reload",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200)))
            ],
          ),);
    }
      },
    );
  }

  Widget todosContainer(int userId) {
    final userBloc = context.bloc<UsersBloc>();
    userBloc.add(GetTodos(userId));

    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UsersInitial) {
          return Container(color: Colors.grey,);
        } else if (state is Loading) {
          return CircularProgressIndicator();
        } else if (state is TodosLoaded) {
          return todosLoaded(state.todosFuture);
        } else {
          return Container(height: 150,padding: const EdgeInsets.all(20),decoration: const BoxDecoration(color: Color(
              0xFF157815),borderRadius: BorderRadius.all(Radius.circular(20))),child: Column(
            children: [
              Text('There was a problem fetching the data. Is your device online?',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
              Icon(Icons.error_outline,color: Color(0xFF920000),),
              ElevatedButton(onPressed: (){
                final userBloc = context.bloc<UsersBloc>();
                userBloc.add(GetTodos(userId));
              }, child: Text("Reload",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200)))
            ],
          ),);
        }
      },
    );


  }
  
  Widget usersLoaded(Future userFuture) {
    List<bool> _isOpen;


    return Container(margin: const EdgeInsets.all(20),padding: const EdgeInsets.all(10),alignment: Alignment.center,decoration: const BoxDecoration(color: Color(
        0xFF0A4C0A),borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children:  const [
                Padding(padding: EdgeInsets.only(left: 7),child: Text("Users",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200,fontSize: 20,letterSpacing: 1.5,),textAlign: TextAlign.start,)),
              ],
            ),
            const Divider(color: Color(0xFF157815),),
            FutureBuilder(
                    future: userFuture,
                    builder: (context, snapshot) {


                      while(snapshot.data == null) {
                        print("response data is still null");
                        return CircularProgressIndicator();
                      }
                      return ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return ListView(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(margin: const EdgeInsets.all(5),padding: const EdgeInsets.all(10),alignment: Alignment.center,decoration: const BoxDecoration(color: Color(
                                        0xFF157815),borderRadius: BorderRadius.all(Radius.circular(20))),
                                      child: ExpansionTile(
                                            title: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(snapshot.data[i].name,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.phone,color: Color(
                                                            0xB70A4C0A),),Text(snapshot.data[i].phone,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.mail,color: Color(
                                                            0xB70A4C0A)),Text(snapshot.data[i].email,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                /*Text(snapshot.data[i].street['street']),
                                                Text("jjjj"),*/
                                              ],
                                            ),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_rounded,color: Color(
                                                0xB70A4C0A),),Text(snapshot.data[i].street["street"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone,color: Color(
                                                0xA4C0A),),Text(snapshot.data[i].street["city"] + ", ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                            Text(snapshot.data[i].street["zipcode"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),)
                                          ],
                                        ),
                                        const Divider(color: Color(0xFF0A4C0A),)
                                      ],
                                    ),
                                  )
                                  ,
                                  ListTile(trailing: Icon(Icons.arrow_right_alt_sharp,color:const Color(
                                      0xFF339233) ,),
                                onTap: (){
                                    print("you tapped the tile");

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(
                                      create: (context) => UsersBloc(UserRepository()),
                                      child: TodosPage(nameOfUser: snapshot.data[i].name,idOfUser: snapshot.data[i].id,),
                                    ) ));



                                    },
                                title: Text("View Todos",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                )
                                ],

                                        ),

                                    )]
                                )
                                  /*ExpansionPanelList(
                                    children: [
                                      ExpansionPanel(headerBuilder: (context, _isOpen){
                                        return const Text("data");
                                      }, body: const Text("data2"),isExpanded: _isOpen[0],canTapOnHeader: true)
                                    ],
                                    expansionCallback: (i, isOpen) =>
                                        setState(() =>
                                        _isOpen[i] = !isOpen
                                        ))*/;
                              }
                          );

                    }
                ),
          ],
        ),
      ),

    );

  }

  Widget todosLoaded(Future userFuture) {


    return Container(margin: const EdgeInsets.all(20),padding: const EdgeInsets.all(10),alignment: Alignment.center,decoration: const BoxDecoration(color: Color(
        0xFF0A4C0A),borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children:  const [
                Padding(padding: EdgeInsets.only(left: 7),child: Text("Users",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200,fontSize: 20,letterSpacing: 1.5,),textAlign: TextAlign.start,)),
              ],
            ),
            const Divider(color: Color(0xFF157815),),
            FutureBuilder(
                future: userFuture,
                builder: (context, snapshot) {


                  while(snapshot.data == null) {
                    print("response data is still null");
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return ListView(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(margin: const EdgeInsets.all(5),padding: const EdgeInsets.all(10),alignment: Alignment.center,decoration: const BoxDecoration(color: Color(
                                  0xFF157815),borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: ExpansionTile(
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(snapshot.data[i].name,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.phone,color: Color(
                                                  0xB70A4C0A),),Text(snapshot.data[i].phone,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.mail,color: Color(
                                                  0xB70A4C0A)),Text(snapshot.data[i].email,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),)
                                            ],
                                          )
                                        ],
                                      ),
                                      /*Text(snapshot.data[i].street['street']),
                                                Text("jjjj"),*/
                                    ],
                                  ),
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_rounded,color: Color(
                                                  0xB70A4C0A),),Text(snapshot.data[i].street["street"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.phone,color: Color(
                                                  0xA4C0A),),Text(snapshot.data[i].street["city"] + ", ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                              Text(snapshot.data[i].street["zipcode"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),)
                                            ],
                                          ),
                                          const Divider(color: Color(0xFF0A4C0A),)
                                        ],
                                      ),
                                    )
                                    ,
                                    ListTile(trailing: Icon(Icons.arrow_right_alt_sharp,color:const Color(
                                        0xFF339233) ,),
                                      onTap: (){
                                        print("you tapped the tile");
                                        userName = snapshot.data[i].name;
                                        print(userName);



                                      },
                                      title: Text("View Todos",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                                    )
                                  ],

                                ),

                              )]
                        )
                        /*ExpansionPanelList(
                                    children: [
                                      ExpansionPanel(headerBuilder: (context, _isOpen){
                                        return const Text("data");
                                      }, body: const Text("data2"),isExpanded: _isOpen[0],canTapOnHeader: true)
                                    ],
                                    expansionCallback: (i, isOpen) =>
                                        setState(() =>
                                        _isOpen[i] = !isOpen
                                        ))*/;
                      }
                  );

                }
            ),
          ],
        ),
      ),

    );




  }

/*  Widget userPageDataState () {
    Future.


    if(Future) {
      print("returning usersContainer");
      return usersContainer();
    } else {
      print("returning usersLoaded");
      return usersLoaded(futureForUsers);
    }
  }*/




}










class PageOne extends StatefulWidget {
  const PageOne({Key key}) : super(key: key);


  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
    );
  }
}
////////////////////////////////////////
class PageTwo extends StatefulWidget {
  const PageTwo({Key key}) : super(key: key);


  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}














class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    Key key,
    this.index,
    this.children,
    this.duration = const Duration(
      milliseconds: 800,
    ),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
