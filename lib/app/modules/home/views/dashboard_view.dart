part of 'home_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: ((context, innerBoxIsScrolled) => []),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true, //fix without Safe area padding top
        child: ListView(
            // SliverChildBuildDelegate
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: []),
      ),
    );
  }
}
