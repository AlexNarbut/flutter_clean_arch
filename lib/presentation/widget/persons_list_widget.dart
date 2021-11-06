import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clear_arch/domain/entities/person_entity.dart';
import 'package:flutter_clear_arch/presentation/bloc/find_person_bloc/find_bloc.dart';
import 'package:flutter_clear_arch/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_clear_arch/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:flutter_clear_arch/presentation/widget/person_card_widget.dart';

import 'error_widget.dart';

class PersonsList extends StatefulWidget {

  @override
  State createState() {return _PersonsListState();}
}


class _PersonsListState extends State<PersonsList> {
  final scrollController = ScrollController();
  int page = -1;

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          //BlocProvider.of<PersonListCubit>(context).loadPerson();
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<PersonListCubit>().loadPerson();
  }


  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return BlocBuilder<PersonListCubit, PersonState>(builder: (context, state) {
      List<PersonEntity> persons = [];
      bool isLoading = false;

      if (state is PersonLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is PersonLoading) {
        persons = state.oldPersonsList;
        isLoading = true;
      } else if (state is PersonLoaded) {
        persons = state.personsList;
      } else if (state is PersonError) {
        return  AppErrorWidget(error: state.message,onTap:(){
          context.read<PersonListCubit>().loadPerson();
        },);

          Text(
          state.message,
          style: TextStyle(color: Colors.white, fontSize: 25),
        );
      }
      return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < persons.length) {
            return PersonCard(person: persons[index]);
          } else {
            Timer(Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });
            return _loadingIndicator();
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: persons.length + (isLoading ? 1 : 0),
      );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
