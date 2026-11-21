import { LearningArticle, MoodOption, FaqItem, SupportQuestion } from '../types';

export const LEARNING_ARTICLES: LearningArticle[] = [
  {
    id: 'depression',
    category: 'Understanding',
    title: 'Understanding depression',
    summary: 'A starting point for learning what depression can involve.',
    sections: [
      'Depression is more than having a difficult day or feeling sad for a short time. It can affect how someone feels, thinks, sleeps, relates to others, and manages everyday activities.',
      'People experience it differently. There is no single description that fits everyone, and reading an article cannot tell you whether you have depression.',
      'If changes in mood or daily life are persistent or worrying, consider speaking with a qualified health professional or someone you trust who can help you find appropriate support.',
    ],
    contentVersion: '0.1.0',
    reviewStatus: 'Prototype copy · clinical review required',
  },
  {
    id: 'anxiety',
    category: 'Understanding',
    title: 'Understanding anxiety',
    summary: 'Learn about worry, fear, and how anxiety may show up.',
    sections: [
      'Anxiety is a human response to uncertainty or perceived threat. For some people, it can become intense, frequent, or difficult to manage.',
      'Experiences vary. Some people notice racing thoughts, tension, restlessness, or changes in sleep. These experiences can have different causes and are not a diagnosis by themselves.',
      'A qualified professional can help you understand persistent or distressing symptoms and discuss appropriate support.',
    ],
    contentVersion: '0.1.0',
    reviewStatus: 'Prototype copy · clinical review required',
  },
  {
    id: 'stress',
    category: 'Everyday wellbeing',
    title: 'Making sense of everyday stress',
    summary: 'A gentle introduction to stress and daily pressures.',
    sections: [
      'Stress can be a response to demands, uncertainty, or change. It may affect people emotionally, physically, and socially.',
      'There is no one-size-fits-all response to stress. What feels manageable for one person may feel overwhelming to another.',
      'If stress is affecting your safety, health, or ability to manage daily life, consider reaching out to a qualified professional or trusted support person.',
    ],
    contentVersion: '0.1.0',
    reviewStatus: 'Prototype copy · clinical review required',
  },
  {
    id: 'professional-help',
    category: 'Finding support',
    title: 'When to seek professional support',
    summary: 'Understand why and when talking to a qualified person may help.',
    sections: [
      'You do not need to wait until things feel unbearable to ask for support. It can be reasonable to speak with a qualified professional when something is worrying you or affecting everyday life.',
      'A health professional can listen, ask questions, and help you understand available options. You can ask about their qualifications, fees, confidentiality, and the kind of support they provide.',
      'If you or someone else may be in immediate danger, seek urgent in-person help from local emergency services or a trusted person. MindBridge is not monitored and cannot dispatch assistance.',
    ],
    contentVersion: '0.1.0',
    reviewStatus: 'Prototype copy · clinical review required',
  },
];

export const FAQ_ITEMS: FaqItem[] = [
  {
    id: 'faq-1',
    question: 'Is MindBridge a therapy app?',
    answer: 'No. MindBridge is being designed to make mental health information easier to understand and professional support easier to find. It does not provide therapy or replace a qualified professional.',
  },
  {
    id: 'faq-2',
    question: 'Can MindBridge diagnose depression or anxiety?',
    answer: 'No. It will not diagnose conditions, prescribe medication, or provide treatment instructions. A qualified health professional is the right person to assess personal health concerns.',
  },
  {
    id: 'faq-3',
    question: 'Will it be available in Hausa?',
    answer: "That's part of the plan. English and Hausa are intended to be supported, with translations reviewed for clarity and cultural context before release.",
  },
  {
    id: 'faq-4',
    question: 'Can I use it without an internet connection?',
    answer: 'Selected educational content is planned to work offline. The exact offline experience is still being developed and tested.',
  },
  {
    id: 'faq-5',
    question: 'Is the app available to download now?',
    answer: "Not yet. MindBridge is in development. We'll publish official download links here when a tested release is ready. Please be cautious of unofficial downloads.",
  },
];

export const MOOD_OPTIONS: MoodOption[] = [
  { id: 'bright', symbol: '☀', label: 'Bright', description: 'A little lighter today' },
  { id: 'calm', symbol: '◒', label: 'Calm', description: 'Steady for now' },
  { id: 'worried', symbol: '⌁', label: 'Worried', description: 'A lot on my mind' },
  { id: 'sad', symbol: '○', label: 'Sad', description: 'Things feel heavy' },
  { id: 'anxious', symbol: '〰', label: 'Anxious', description: 'Feeling unsettled' },
  { id: 'overwhelmed', symbol: '⋯', label: 'Overwhelmed', description: 'More than I can hold' },
];

export const SUPPORT_PROMPTS: SupportQuestion[] = [
  { id: 'q1', text: 'What qualifications and experience do you have?' },
  { id: 'q2', text: 'What kinds of support do you offer?' },
  { id: 'q3', text: 'What are the costs and available options?' },
  { id: 'q4', text: 'How is my information kept private?' },
];

export const GROUNDING_STEPS = [
  { count: '5', label: 'things you can see around you' },
  { count: '4', label: 'things you can gently touch or feel' },
  { count: '3', label: 'sounds you can hear right now' },
  { count: '2', label: 'things you can smell or notice' },
  { count: '1', label: 'kind thought or breath for yourself' },
];
