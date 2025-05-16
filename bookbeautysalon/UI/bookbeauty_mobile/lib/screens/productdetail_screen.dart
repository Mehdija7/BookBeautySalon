import 'dart:convert';
import 'package:book_beauty/models/commentproduct.dart';
import 'package:book_beauty/providers/commentproduct_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/review_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/review_stars.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ReviewProvider _reviewProvider = ReviewProvider();
  double rating = 0.0;
  bool isLoading = false;
  final CommentProductProvider _commentProductProvider =
      CommentProductProvider();
  List<CommentProduct> commentProducts = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
    _fetchAverage();
  }

  void buy() {
    final provider = Provider.of<OrderItemProvider>(context, listen: false);
    provider.addProduct(widget.product);
  }

  void _fetchAverage() async {
    var r = await _reviewProvider.getAverageRating(widget.product.productId!);
    setState(() {
      rating = r;
    });
  }


  fetchComments() async {
    try {
      var r = await _commentProductProvider.get();
      var list = r.result
          .where((comment) => comment.productId == widget.product.productId);
      setState(() {
        commentProducts = list.toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addComment(CommentProduct comment) async {
    await _commentProductProvider.insert(comment);
    await fetchComments();
    setState(() {});
  }

  void _openAddCategoryOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          CommentsSection(addComment, widget.product, commentProducts),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text(''),
              backgroundColor: const Color.fromARGB(157, 201, 198, 198),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width:  MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              color: const Color.fromARGB(157, 201, 198, 198),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainTitle(title: widget.product.name!),
                    widget.product.image != null
                        ? Image.memory(
                            base64Decode(widget.product
                                .image!),
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/logoBB.png", 
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ReviewStars(
                                        average: rating, product: widget.product),
                            
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.product.description!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            '${widget.product.price} BAM',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: buy,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              backgroundColor:
                                  const Color.fromARGB(255, 134, 165, 185),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Buy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.comment,
                                size: 20, color: Colors.grey),
                            onPressed: () {
                              _openAddCategoryOverlay();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CommentsSection extends StatefulWidget {
  const CommentsSection(this.onAddComment, this.product, this.comments,
      {super.key});

  final void Function(CommentProduct comment) onAddComment;
  final Product product;
  final List<CommentProduct> comments;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
     
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Comments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: widget.comments.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.comments.length,
                        itemBuilder: (ctx, index) {
                          final comment = widget.comments[index];
                          String date = DateFormat('yyyy/MM/dd HH:mm').format(comment.commentDate!.toLocal());
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(comment.commentText!,style: 
                              TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text(
                                '${comment.user!.username!}   $date'
                                    .split('.')[0],
                                style: TextStyle(
                                  fontStyle: FontStyle.italic
                                ),    
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("There is no comments.")),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, keyboardSpace + 16),
                child: Column(
                  children: [
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              labelText: 'Add comment',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel',
                          style: TextStyle(
                            color:Color.fromARGB(255, 132, 132, 104),
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                        ElevatedButton(
                           style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 167, 160, 125)),
  ),
                          onPressed: () async {
                            if (_titleController.text.trim().isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("TThe input field is required."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              try {
                                CommentProduct newComment = CommentProduct(
                                  commentDate: DateTime.now(),
                                  userId: UserProvider.getUserId,
                                  commentText: _titleController.text,
                                  productId: widget.product.productId,
                                );
                                widget.onAddComment(newComment);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Comment added successfully."),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pop(context);
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Adding comment was unsuccessfully."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      )
                                    ],
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Save',style: TextStyle(
                            color:Color.fromARGB(255, 72, 72, 71),
                           
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
