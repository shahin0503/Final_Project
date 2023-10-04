import 'package:blogapp/utilities/portfolio/add_project_dialog.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddPortfolioView extends StatefulWidget {
  const AddPortfolioView({super.key});

  @override
  State<AddPortfolioView> createState() => _AddPortfolioViewState();
}

class _AddPortfolioViewState extends State<AddPortfolioView> {
  late TextfieldTagsController _skills;

  @override
  void initState() {
    super.initState();
    _skills = TextfieldTagsController();
  }

  @override
  void dispose() {
    super.dispose();
    _skills.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Portfolio'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                    TextFieldTags(
                      textfieldTagsController: _skills,
                      initialTags: const [],
                      textSeparators: const [' ', ','],
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if (_skills.getTags!.contains(tag)) {
                          return 'you already entered that';
                        }
                        return null;
                      },
                      inputfieldBuilder:
                          (context, tec, fn, error, onChanged, onSubmitted) {
                        return ((context, sc, tags, onTagDelete) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: tec,
                              focusNode: fn,
                              decoration: InputDecoration(
                                isDense: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                    width: 3.0,
                                  ),
                                ),
                                helperText: 'Enter Skills...',
                                helperStyle: const TextStyle(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                ),
                                hintText: _skills.hasTags ? '' : "Enter tag...",
                                errorText: error,
                                prefixIconConstraints:
                                    BoxConstraints(maxWidth: width * 0.74),
                                prefixIcon: tags.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 74, 137, 92),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onTap: () {},
                                                ),
                                                const SizedBox(width: 4.0),
                                                InkWell(
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    size: 14.0,
                                                    color: Color.fromARGB(
                                                        255, 233, 233, 233),
                                                  ),
                                                  onTap: () {
                                                    onTagDelete(tag);
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList()),
                                      )
                                    : null,
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                            ),
                          );
                        });
                      },
                    ),
                    InkWell(
                      child: Text('Add Projects'),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AddProjectDialog();
                          },
                        );
                      },
                    )
                  ],
                ));
          },
        ));
  }
}
