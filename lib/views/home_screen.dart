import 'package:aplikasi_berita/controllers/news_controller.dart';
import 'package:aplikasi_berita/views/component/sideDrawer.dart';
import 'package:aplikasi_berita/views/view_news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  NewsControl newsControl = Get.put(NewsControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Berita App'),
        actions: [
          IconButton(
            onPressed: (){
              newsControl.country.value='';
              newsControl.category.value='';
              newsControl.findNews.value='';

              newsControl.cName.value='';
              newsControl.getNews(reload: true);
              newsControl.update();
            }, icon: Icon(Icons.refresh),
          ),
          GetBuilder<NewsControl>(
            builder: (controller) => Switch(
              value: controller.isSwitched==true?true:false,
              onChanged: (value) => controller.changeTheme(value),
              activeTrackColor: Colors.white,
              activeColor: Colors.blue,
            ),
            init: NewsControl(),
            )
        ],
      ),


      drawer: sideDrawer(newsControl),
      body: GetBuilder<NewsControl>(builder: (controller){
        return controller.notFound.value ? Center(
          child: Text("Tidak Ditemukan...", style: TextStyle(fontSize: 30))) : controller.news.length == 0 ? Center(
            child: CircularProgressIndicator()) : ListView.builder(controller: controller.scrollController ,
            itemBuilder: (context, index){
              return Column(
                children: [
                  Padding( padding: EdgeInsets.all(5),
                  child: Card( elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                  child: GestureDetector(
                    onTap: () => Get.to(ViewNews(
                      newsUrl: controller.news[index].url)),
                    child: Container( padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30)),
                      child: Column(children: [
                        Stack(children: [
                          controller.news[index].urlToImage ==
                          null
                          ? Container() 
                          : ClipRRect(
                            borderRadius:
                            BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              placeholder: (context,
                              url) => 
                              Container(
                                child: CircularProgressIndicator()),
                                errorWidget: 
                                (context, url, error) => 
                                Icon(Icons.error),
                                imageUrl: controller
                                .news[index]
                                .urlToImage ??
                                '',
                                ),
                            ),
                            Positioned(bottom: 8, right: 8,
                            child: Card(elevation: 0, color: Theme.of(context).primaryColor.withOpacity(0.8),
                            child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
                            child: Text("${controller.news[index].source.name}",style: Theme.of(context).textTheme.subtitle2,
                            ),
                            ),
                            ))
                        ],
                        ),
                        Divider(),
                        Text("${controller.news[index].title}", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 18),
                          )
                      ]),
                    ),
                  ),
                )),
                index == controller.news.length - 1 &&
                controller.isLoading == true
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
            ]);
        },itemCount: controller.news.length,
        );
      }, init: NewsControl(),
      ),
    );
  }
}