import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:namaz_time/core/theme/theme_color.dart';
import 'package:namaz_time/features/location/location_cubit/location_cubit.dart';
import 'package:namaz_time/features/namaz_time/presentation/cubit/namaz_time_cubit.dart';
import 'package:namaz_time/features/notification_remain_time/controller/notification_controller.dart';
import 'package:namaz_time/features/notification_remain_time/timer_bloc/timer_bloc.dart';

import '../../../../core/theme/size_constants.dart';
import '../../../../dependency_injection.dart';
import '../../../location/location_detail_cubit/locationdetail_cubit.dart';
import 'coundown_timer.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  late LocationdetailCubit locationdetailCubit;

  @override
  void initState() {
    super.initState();
    locationdetailCubit = sl<LocationdetailCubit>();
  }

  final _today = HijriCalendar.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationdetailCubit>(
      create: (context) => locationdetailCubit,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: Sizes.dimen_2,
                  blurRadius: Sizes.dimen_10,
                  offset: Offset(
                    Sizes.dimen_2,
                    Sizes.dimen_10,
                  ))
            ],
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                kLightAccent,
                kLightPrimary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        margin: EdgeInsets.all(15.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: Sizes.dimen_10.w),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(backgroundColor: Colors.white, radius: 75.r),
                BlocBuilder<NamazTimeCubit, NamazTimeState>(
                  builder: (context, state) {
                    if (state is NamazTimeLoaded) {
                      TimingController? controller;
                      controller = TimingController(state.namazTimeList);
                      return BlocProvider<TimerCubit>(
                        create: (context) => TimerCubit(controller!.time),
                        child: const CoundownTimerWidget(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
            SizedBox(width: Sizes.dimen_10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Sizes.dimen_10.h),
                  Row(
                    children: [
                      // FaIcon(
                      //   FontAwesomeIcons.solidMoon,
                      //   size: 17.h,
                      // ),
                      const SizedBox(width: Sizes.dimen_2),
                      Text(
                        _today.toFormat("MMMM dd, yyyy"),
                        maxLines: 2,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: kLightTextColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      // FaIcon(
                      //   FontAwesomeIcons.calendarAlt,
                      //   size: Sizes.dimen_20.h,
                      // ),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMMd().format(DateTime.now()),
                          maxLines: 1,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: kLightTextColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // FaIcon(
                      //   Icons.location_on,
                      //   size: Sizes.dimen_23.h,
                      // ),
                      BlocBuilder<LocationdetailCubit, LocationdetailState>(
                        builder: (context, state) {
                          if (state is LocationdetailLoaded) {
                            return Expanded(
                              child: Text(
                                state.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: kLightTextColor),
                              ),
                            );
                          }
                          if (state is LocationLoading) {
                            return Text(
                              'loading...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: kLightTextColor),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // BlocProvider<TimerCubit>(
                  //   create: (context) => TimerCubit(controller.time),
                  //   child: const CoundownTimerWidget(),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
