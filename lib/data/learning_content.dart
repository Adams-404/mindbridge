class LearningArticle {
  const LearningArticle({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.sections,
    this.source,
    this.reviewer,
    this.reviewDate,
    this.contentVersion = '0.1.0',
    this.reviewStatus = 'Curated educational material · WHO & NIMH guidelines',
  });

  final String id;
  final String category;
  final String title;
  final String summary;
  final List<String> sections;
  final String? source;
  final String? reviewer;
  final DateTime? reviewDate;
  final String contentVersion;
  final String reviewStatus;
}

const learningArticles = <LearningArticle>[
  LearningArticle(
    id: 'depression',
    category: 'Understanding',
    title: 'Understanding depression',
    summary: 'A starting point for learning what depression can involve.',
    sections: [
      'Depression is more than having a difficult day or feeling sad for a short time. It can affect how someone feels, thinks, sleeps, relates to others, and manages everyday activities.',
      'People experience it differently. There is no single description that fits everyone, and reading an article cannot tell you whether you have depression.',
      'If changes in mood or daily life are persistent or worrying, consider speaking with a qualified health professional or someone you trust who can help you find appropriate support.',
    ],
  ),
  LearningArticle(
    id: 'anxiety',
    category: 'Understanding',
    title: 'Understanding anxiety',
    summary: 'Learn about worry, fear, and how anxiety may show up.',
    sections: [
      'Anxiety is a human response to uncertainty or perceived threat. For some people, it can become intense, frequent, or difficult to manage.',
      'Experiences vary. Some people notice racing thoughts, tension, restlessness, or changes in sleep. These experiences can have different causes and are not a diagnosis by themselves.',
      'A qualified professional can help you understand persistent or distressing symptoms and discuss appropriate support.',
    ],
  ),
  LearningArticle(
    id: 'stress',
    category: 'Everyday wellbeing',
    title: 'Making sense of everyday stress',
    summary: 'A gentle introduction to stress and daily pressures.',
    sections: [
      'Stress can be a response to demands, uncertainty, or change. It may affect people emotionally, physically, and socially.',
      'There is no one-size-fits-all response to stress. What feels manageable for one person may feel overwhelming to another.',
      'If stress is affecting your safety, health, or ability to manage daily life, consider reaching out to a qualified professional or trusted support person.',
    ],
  ),
  LearningArticle(
    id: 'professional-help',
    category: 'Finding support',
    title: 'When to seek professional support',
    summary: 'Understand why and when talking to a qualified person may help.',
    sections: [
      'You do not need to wait until things feel unbearable to ask for support. It can be reasonable to speak with a qualified professional when something is worrying you or affecting everyday life.',
      'A health professional can listen, ask questions, and help you understand available options. You can ask about their qualifications, fees, confidentiality, and the kind of support they provide.',
      'If you or someone else may be in immediate danger, seek urgent in-person help from local emergency services or a trusted person. MindBridge is not monitored and cannot dispatch assistance.',
    ],
  ),
];
