export interface LearningArticle {
  id: string;
  category: string;
  title: string;
  summary: string;
  sections: string[];
  source?: string;
  reviewer?: string;
  reviewDate?: string;
  contentVersion: string;
  reviewStatus: string;
}

export interface MoodOption {
  id: string;
  symbol: string;
  label: string;
  description: string;
}

export type ExerciseType = 'breathing' | 'grounding' | 'bodyPause';

export type Language = 'en' | 'ha';

export interface CheckInRecord {
  id: string;
  timestamp: string;
  moodId: string;
  note?: string;
}

export interface SupportQuestion {
  id: string;
  text: string;
  description?: string;
}

export interface FaqItem {
  id: string;
  question: string;
  answer: string;
}
