class FaqTypes {
  final int id;
  final String value;

  FaqTypes({required this.id, required this.value});
}

List<FaqTypes> faqTypes = [
  FaqTypes(id: 0, value: "All"),
  FaqTypes(id: 1, value: "Services"),
  FaqTypes(id: 2, value: "AlGeneral"),
  FaqTypes(id: 3, value: "Account"),
];

class FaqQuestion {
  final int id;
  final int typeId;
  final String question;
  final String description;

  FaqQuestion({
    required this.id,
    required this.typeId,
    required this.question,
    required this.description,
  });
}

//Make a list of 10 question for elearning
List<FaqQuestion> faqQuestion = [
  FaqQuestion(
    id: 0,
    typeId: 0,
    question: "Can I access my course offline",
    description:
        "Yes, you can. Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.",
  ),
  FaqQuestion(
    id: 1,
    typeId: 1,
    question: "Can I access my course offline",
    description:
        "Yes, you can. Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.",
  ),
  FaqQuestion(
    id: 2,
    typeId: 0,
    question: "Can I access my course offline",
    description:
        "Yes, you can. Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.",
  ),
  FaqQuestion(
    id: 3,
    typeId: 2,
    question: "Can I access my course offline",
    description:
        "Yes, you can. Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content.",
  ),
];
