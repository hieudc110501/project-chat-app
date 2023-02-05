import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/show_search_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  static const String routeName = '/search-screen';
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');

    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });
      return () {};
    }, [controller]);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Flexible(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.clear();
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: ShowSearchView(name: searchTerm.value),
            ),
          ],
        ),
      ),
    );
  }
}
