// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:staypal/constants/app_constants.dart';
// import 'package:staypal/constants/color_constants.dart';
// import 'package:staypal/screens/admin/viewmodels/EventOrganizerViewModel.dart';
// import 'package:staypal/screens/admin/views/edit_event_view.dart';
// import 'package:staypal/screens/admin/views/add_event_view.dart';
// import 'package:staypal/widgets/add_button.dart';
//
// class EventOrganizerView extends StatelessWidget {
//   const EventOrganizerView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => EventOrganizerViewModel()..fetchMyEvents(),
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//   backgroundColor: AppColors.white,
//   elevation: 0.5,
//   iconTheme: const IconThemeData(color: AppColors.primary),
//   title: const Padding(
//     padding: EdgeInsets.only(left: AppPadding.horizontalPaddingTitle,
//     top: AppPadding.horizontalPadding),
//     child: Text(
//       'Event Organizer Panel',
//       style: TextStyle(
//         fontSize: AppFontSizes.title,
//         fontWeight: FontWeight.bold,
//         color: AppColors.black,
//       ),
//     ),
//   ),
// ),
//
//         floatingActionButton: AddButton(
//           targetView: const AddEventView(),
//           onReturn: () {
//             context.read<EventOrganizerViewModel>().fetchMyEvents();
//           },
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(AppPadding.screenPadding),
//           child: Consumer<EventOrganizerViewModel>(
//             builder: (context, vm, _) {
//               if (vm.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (vm.myEvents.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No events found.',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.subtitle,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 );
//               }
//
//               return ListView.separated(
//                 itemCount: vm.myEvents.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.cardVerticalMargin),
//                 itemBuilder: (context, index) {
//                   final event = vm.myEvents[index];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(AppBorderRadius.card),
//                       border: Border.all(color: AppColors.greyTransparent),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppPadding.horizontalPadding,
//                         vertical: AppPadding.iconPadding,
//                       ),
//                       title: Text(
//                         event.name,
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.subtitle,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Text(
//                         event.date?.toLocal().toString().split(" ")[0] ?? 'No date',
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.body,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       trailing: Wrap(
//                         spacing: AppSpacing.xSmall,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: AppColors.primary),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => EditEventView(event: event),
//                                 ),
//                               ).then((_) {
//                                 context.read<EventOrganizerViewModel>().fetchMyEvents();
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: AppColors.primary),
//                             onPressed: () async {
//                               final confirm = await showDialog<bool>(
//                                 context: context,
//                                 builder: (_) => AlertDialog(
//                                   title: const Text('Delete Event'),
//                                   content: const Text('Are you sure you want to delete this event?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, false),
//                                       child: const Text('Cancel'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, true),
//                                       child: const Text('Delete'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                               if (confirm == true) {
//                                 await context.read<EventOrganizerViewModel>().deleteEvent(event.eventId);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text(' Event deleted')),
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:staypal/constants/app_constants.dart';
// import 'package:staypal/constants/color_constants.dart';
// import 'package:staypal/screens/admin/views/add_event_view.dart';
// import 'package:staypal/screens/admin/views/edit_event_view.dart';
// import 'package:staypal/screens/admin/views/my_ratings_manager_view.dart';
// import 'package:staypal/screens/admin/views/event_organizer_bookings_view.dart';
// import 'package:staypal/screens/admin/viewmodels/EventOrganizerViewModel.dart';
// import 'package:staypal/widgets/add_button.dart';
// import 'package:staypal/widgets/drawer.dart';
//
// class EventOrganizerView extends StatelessWidget {
//   const EventOrganizerView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => EventOrganizerViewModel()..fetchMyEvents(),
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         drawer: CustomRoleDrawer(
//           roleTitle: 'Event Organizer',
//           optionTitle: 'My Events',
//           optionIcon: Icons.event,
//           onManageTap: () {
//             Navigator.pop(context);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const EventOrganizerView()),
//             );
//           },
//           onReviewsTap: () {
//             Navigator.pop(context);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const MyRatingsManagerView()),
//             );
//           },
//           onBookingsTap: () {
//             Navigator.pop(context);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const EventOrganizerBookingsView()),
//             );
//           },
//         ),
//         appBar: AppBar(
//           backgroundColor: AppColors.white,
//           elevation: 0.5,
//           iconTheme: const IconThemeData(color: AppColors.primary),
//           title: const Padding(
//             padding: EdgeInsets.only(
//               left: AppPadding.horizontalPaddingTitle,
//               top: AppPadding.horizontalPadding,
//             ),
//             child: Text(
//               'Event Organizer Panel',
//               style: TextStyle(
//                 fontSize: AppFontSizes.title,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.black,
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: AddButton(
//           targetView: const AddEventView(),
//           onReturn: () {
//             context.read<EventOrganizerViewModel>().fetchMyEvents();
//           },
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(AppPadding.screenPadding),
//           child: Consumer<EventOrganizerViewModel>(
//             builder: (context, vm, _) {
//               if (vm.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (vm.myEvents.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No events found.',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.subtitle,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 );
//               }
//
//               return ListView.separated(
//                 itemCount: vm.myEvents.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.cardVerticalMargin),
//                 itemBuilder: (context, index) {
//                   final event = vm.myEvents[index];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(AppBorderRadius.card),
//                       border: Border.all(color: AppColors.greyTransparent),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppPadding.horizontalPadding,
//                         vertical: AppPadding.iconPadding,
//                       ),
//                       title: Text(
//                         event.name,
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.subtitle,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Text(
//                         event.date.toLocal().toString().split(" ")[0],
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.body,
//                           color: AppColors.black,
//                         ),
//                       ),
//                       trailing: Wrap(
//                         spacing: AppSpacing.xSmall,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: AppColors.primary),
//                             onPressed: () async {
//                               await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => EditEventView(event: event),
//                                 ),
//                               );
//                               context.read<EventOrganizerViewModel>().fetchMyEvents();
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: AppColors.primary),
//                             onPressed: () async {
//                               final confirm = await showDialog<bool>(
//                                 context: context,
//                                 builder: (_) => AlertDialog(
//                                   title: const Text('Delete Event'),
//                                   content: const Text('Are you sure you want to delete this event?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, false),
//                                       child: const Text('Cancel'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, true),
//                                       child: const Text('Delete'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                               if (confirm == true) {
//                                 await context.read<EventOrganizerViewModel>().deleteEvent(event.eventId);
//                                 if (context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Event deleted')),
//                                   );
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staypal/constants/app_constants.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/screens/admin/viewmodels/EventOrganizerViewModel.dart';
import 'package:staypal/screens/admin/views/add_event_view.dart';
import 'package:staypal/screens/admin/views/edit_event_view.dart';
import 'package:staypal/screens/admin/views/event_organizer_bookings_view.dart';
import 'package:staypal/widgets/add_button.dart';
import 'package:staypal/widgets/drawer.dart';

import 'event_organizer_rating_view.dart';

class EventOrganizerView extends StatelessWidget {
const EventOrganizerView({super.key});

@override
Widget build(BuildContext context) {
return ChangeNotifierProvider(
create: (_) => EventOrganizerViewModel()
..fetchMyEvents()
..fetchTicketsForMyEvents(),
child: Scaffold(
backgroundColor: AppColors.white,
drawer: CustomRoleDrawer(
roleTitle: 'Event Organizer',
optionTitle: 'My Events',
optionIcon: Icons.event,
onManageTap: () {
Navigator.pop(context);
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const EventOrganizerView()),
);
},
onBookingsTap: () {
Navigator.pop(context);
Navigator.push(
context,
MaterialPageRoute(builder: (_) => const EventOrganizerBookingsView()),
);
},
onReviewsTap: () {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const EventOrganizerRatingView()),
  );
},
),
appBar: AppBar(
backgroundColor: AppColors.white,
elevation: 0.5,
iconTheme: const IconThemeData(color: AppColors.primary),
title: const Padding(
padding: EdgeInsets.only(
left: AppPadding.horizontalPaddingTitle,
top: AppPadding.horizontalPadding,
),
child: Text(
'Event Organizer Panel',
style: TextStyle(
fontSize: AppFontSizes.title,
fontWeight: FontWeight.bold,
color: AppColors.black,
),
),
),
),
floatingActionButton: AddButton(
targetView: const AddEventView(),
onReturn: () {
context.read<EventOrganizerViewModel>().fetchMyEvents();
},
),
body: Padding(
padding: const EdgeInsets.all(AppPadding.screenPadding),
child: Consumer<EventOrganizerViewModel>(
builder: (context, vm, _) {
if (vm.isLoading) {
return const Center(child: CircularProgressIndicator());
}

if (vm.myEvents.isEmpty) {
return const Center(
child: Text(
'No events found.',
style: TextStyle(
fontSize: AppFontSizes.subtitle,
color: AppColors.black,
),
),
);
}

return ListView.separated(
itemCount: vm.myEvents.length,
separatorBuilder: (_, __) =>
const SizedBox(height: AppSpacing.cardVerticalMargin),
itemBuilder: (context, index) {
final event = vm.myEvents[index];
return Container(
decoration: BoxDecoration(
color: AppColors.white,
borderRadius:
BorderRadius.circular(AppBorderRadius.card),
border: Border.all(color: AppColors.greyTransparent),
boxShadow: const [
BoxShadow(
color: AppColors.white,
blurRadius: 4,
offset: Offset(0, 2),
),
],
),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(
horizontal: AppPadding.horizontalPadding,
vertical: AppPadding.iconPadding,
),
title: Text(
event.name,
style: const TextStyle(
fontSize: AppFontSizes.subtitle,
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
event.date.toLocal().toString().split(" ")[0],
style: const TextStyle(
fontSize: AppFontSizes.body,
color: AppColors.black,
),
),
trailing: Wrap(
spacing: AppSpacing.xSmall,
children: [
IconButton(
icon: const Icon(Icons.edit,
color: AppColors.primary),
onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
EditEventView(event: event),
),
);
context
    .read<EventOrganizerViewModel>()
    .fetchMyEvents();
},
),
IconButton(
icon: const Icon(Icons.delete,
color: AppColors.primary),
onPressed: () async {
final confirm = await showDialog<bool>(
context: context,
barrierDismissible: false,
builder: (context) => AlertDialog(
title: const Text('Delete Event'),
content: const Text(
'Are you sure you want to delete this event?'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: const Text('Cancel'),
),
TextButton(
onPressed: () => Navigator.pop(context, true),
child: const Text('Delete'),
),
],
),
);

if (confirm == true) {
await context
    .read<EventOrganizerViewModel>()
    .deleteEvent(event.eventId);
if (context.mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Event deleted')),
);
}
}
},
),
],
),
),
);
},
);
},
),
),
),
);
}
}
