import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:music_player/details/screen/details_screen.dart';
import 'package:music_player/home/bloc/music_bloc.dart';
import 'package:music_player/home/bloc/music_event.dart';
import 'package:music_player/home/bloc/music_state.dart';
import 'package:music_player/utils/theme/theme_bloc.dart';
import 'package:music_player/utils/theme/theme_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String emailId;
  final List fav;
  const HomeScreen({super.key, required this.emailId, required this.fav});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController searchController = TextEditingController();
  bool darkButtonTapped = false;
  List favId = [];
  List? listedMusic = [];
  List? listedMusicFilter = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MusicBloc>(context).add(FetchMusicEvent(
      emailId: widget.emailId
    ));
    searchController.addListener(() {
      searchMusic();
    });
  }

  Future<void> prefsData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("favId", favId.map((e) => e.toString()).toList());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  searchMusic() {
    List _listedMusic = [];
    _listedMusic.addAll(listedMusic!);
    if (searchController.text.isNotEmpty) {
      _listedMusic.retainWhere((listedMusic) {
        String searchValue = searchController.text.toLowerCase();
        String listedMusicName = listedMusic.name.toLowerCase();
        return listedMusicName.contains(searchValue);
      });
      setState(() {
        listedMusicFilter = _listedMusic;
      });
    } else {
      setState(() {
        listedMusicFilter = listedMusic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    favId = widget.fav;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: (){
            if(darkButtonTapped == false){
              context.read<ThemeBloc>().add(ThemeEvent(isDark: true));
              darkButtonTapped = true;
            } else {
              context.read<ThemeBloc>().add(ThemeEvent(isDark: false));
              darkButtonTapped = false;
            }
          },
        icon: Icon(darkButtonTapped?Icons.nightlight_rounded:Icons.nightlight_outlined)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Center(
                child: Text(widget.emailId.substring(0,1).toUpperCase()),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome", style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 5),
            Text("Enjoy Your Favourite Music", style: Theme.of(context).textTheme.bodyText2),
            const SizedBox(height: 20),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                hintText: "Search",
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red)
                )
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<MusicBloc, MusicState>(
                listener: (context, state){},
                builder: (context, state){
                  if(state is MusicInitialState){
                    return const Center(child: CircularProgressIndicator());
                  } else if(state is MusicLoadingState){
                    return const Center(child: CircularProgressIndicator());
                  } else if(state is MusicSuccessState){
                    listedMusic = state.musicModel.data;
                    final data = searchController.text.isEmpty?state.musicModel.data!:listedMusicFilter!;
                    return data.isEmpty?const Center(child: Text("No Music Found")):ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  imageUrl: data[index].image ?? "",
                                  name: data[index].name ?? "",
                                  artist: data[index].artist ?? "",
                                  heroTag: 'image_${data[index].id}',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 70,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Hero(
                                        tag: 'image_${data[index].id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                            child: Image.network(data[index].image??""),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data[index].name??""),
                                            Text(data[index].artist??"")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          favId.contains(data[index].id) ? Icons.favorite : Icons.favorite_border,
                                          color: favId.contains(data[index].id)?Colors.pink:Colors.grey,
                                        ),
                                        onPressed: () {
                                          if(favId.contains(data[index].id)){
                                            favId.remove(data[index].id);
                                          } else {
                                            favId.add(data[index].id);
                                          }
                                          prefsData();
                                          setState(() {});
                                        },
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: const Icon(Icons.play_circle, size: 25,),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if(state is MusicFailureState){
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
