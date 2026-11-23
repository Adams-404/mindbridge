class CourseLesson {
  const CourseLesson({
    required this.id,
    required this.title,
    required this.content,
    required this.keyTakeaways,
  });

  final String id;
  final String title;
  final String content;
  final List<String> keyTakeaways;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class CourseQuiz {
  const CourseQuiz({
    required this.questions,
    this.passingScorePercent = 70,
    this.maxAttempts = 3,
  });

  final List<QuizQuestion> questions;
  final int passingScorePercent;
  final int maxAttempts;
}

class QuizAttemptRecord {
  const QuizAttemptRecord({
    required this.courseId,
    required this.scorePercent,
    required this.passed,
    required this.timestamp,
    required this.attemptNumber,
  });

  final String courseId;
  final int scorePercent;
  final bool passed;
  final DateTime timestamp;
  final int attemptNumber;

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'scorePercent': scorePercent,
    'passed': passed,
    'timestamp': timestamp.toIso8601String(),
    'attemptNumber': attemptNumber,
  };

  factory QuizAttemptRecord.fromJson(Map<String, dynamic> json) => QuizAttemptRecord(
    courseId: json['courseId'] as String,
    scorePercent: json['scorePercent'] as int,
    passed: json['passed'] as bool,
    timestamp: DateTime.parse(json['timestamp'] as String),
    attemptNumber: json['attemptNumber'] as int,
  );
}

class CourseCertificate {
  const CourseCertificate({
    required this.certificateId,
    required this.courseId,
    required this.courseTitle,
    required this.recipientName,
    required this.finalScorePercent,
    required this.issuedAt,
  });

  final String certificateId;
  final String courseId;
  final String courseTitle;
  final String recipientName;
  final int finalScorePercent;
  final DateTime issuedAt;

  Map<String, dynamic> toJson() => {
    'certificateId': certificateId,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'recipientName': recipientName,
    'finalScorePercent': finalScorePercent,
    'issuedAt': issuedAt.toIso8601String(),
  };

  factory CourseCertificate.fromJson(Map<String, dynamic> json) => CourseCertificate(
    certificateId: json['certificateId'] as String,
    courseId: json['courseId'] as String,
    courseTitle: json['courseTitle'] as String,
    recipientName: json['recipientName'] as String,
    finalScorePercent: json['finalScorePercent'] as int,
    issuedAt: DateTime.parse(json['issuedAt'] as String),
  );
}

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
    this.estimatedMinutes = 10,
    this.lessons = const [],
    this.quiz,
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
  final int estimatedMinutes;
  final List<CourseLesson> lessons;
  final CourseQuiz? quiz;
}

const learningArticles = <LearningArticle>[
  LearningArticle(
    id: 'depression',
    category: 'Understanding',
    title: 'Understanding depression',
    summary: 'A starting point for learning what depression can involve.',
    estimatedMinutes: 10,
    sections: [
      'Depression is more than having a difficult day or feeling sad for a short time. It can affect how someone feels, thinks, sleeps, relates to others, and manages everyday activities.',
      'People experience it differently. There is no single description that fits everyone, and reading an article cannot tell you whether you have depression.',
      'If changes in mood or daily life are persistent or worrying, consider speaking with a qualified health professional or someone you trust who can help you find appropriate support.',
    ],
    lessons: [
      CourseLesson(
        id: 'dep-1',
        title: 'Clinical Characteristics & Diagnosis',
        content:
            'Major Depressive Disorder is a clinical diagnosis defined in international classification manuals (such as WHO ICD-11 and DSM-5). It requires a cluster of cognitive, affective, and somatic symptoms persisting nearly every day for a minimum of two weeks. Symptoms include persistent low mood, pervasive loss of pleasure (anhedonia), marked fatigue, disruption in sleep or appetite, and unwarranted feelings of worthlessness.',
        keyTakeaways: [
          'Diagnostic criteria require persistent symptoms for at least two weeks',
          'Encompasses physical fatigue and sleep disturbance alongside low mood',
          'Not a reflection of personal character or willpower',
        ],
      ),
      CourseLesson(
        id: 'dep-2',
        title: 'The Cognitive Triad & Inactivity Cycles',
        content:
            'Cognitive psychologist Aaron Beck identified that depression often involves automatic negative cognitive schemas: negative perceptions of the self ("I am inadequate"), the world ("Demands are insurmountable"), and the future ("Nothing will ever improve"). When individuals pull back from social and daily activities in response, they experience less positive reinforcement, unintentionally reinforcing depressive lethargy.',
        keyTakeaways: [
          'Beck\'s cognitive triad distorts perception across self, world, and future',
          'Withdrawal creates an unintended loop of decreased stimulation and worsening mood',
          'Behavioral activation introduces structured micro-activities to break inertia',
        ],
      ),
      CourseLesson(
        id: 'dep-3',
        title: 'Evidence-Based Treatments & Stepped Care',
        content:
            'Global health authorities advocate a stepped-care model. For mild depressive symptoms, structured physical activity, psychoeducation, and guided self-management are first-line recommendations. For moderate to severe presentations, evidence-based psychotherapies (such as Cognitive Behavioral Therapy or Interpersonal Therapy) combined with medical evaluation provide the highest clinical efficacy.',
        keyTakeaways: [
          'Stepped-care adjusts clinical intervention intensity to individual symptom severity',
          'CBT and Interpersonal Therapy possess extensive randomized controlled trial evidence',
          'Immediate safety concerns require emergency intervention, not unmonitored apps',
        ],
      ),
    ],
    quiz: CourseQuiz(
      questions: [
        QuizQuestion(
          question:
              'According to WHO ICD-11 and DSM-5 guidelines, what is the minimum duration symptoms must persist for a diagnosis of major depression?',
          options: ['At least 2 days', 'At least 2 weeks', 'At least 3 months', 'At least 6 months'],
          correctIndex: 1,
          explanation:
              'Clinical guidelines specify that depressive symptoms must be present for at least two consecutive weeks to qualify as a major depressive episode.',
        ),
        QuizQuestion(
          question: 'What is the core rationale behind Behavioral Activation?',
          options: [
            'Waiting until motivation is 100% before starting any task',
            'Scheduling manageable activities to break the withdrawal loop before mood returns',
            'Suppression of all negative feelings through constant distraction',
            'Staying in bed until all sadness subsides',
          ],
          correctIndex: 1,
          explanation:
              'Behavioral activation works from the outside-in: performing structured positive actions breaks the lethargy cycle and stimulates motivation.',
        ),
        QuizQuestion(
          question: 'When should someone consider consulting a qualified mental health clinician?',
          options: [
            'Only during an extreme physical emergency',
            'When persistent distress interferes with daily functioning, work, or relationships',
            'Never, because reading articles is always sufficient',
            'Only if mandated by law',
          ],
          correctIndex: 1,
          explanation:
              'Early clinical consultation is recommended as soon as persistent symptoms begin to impair everyday functioning or wellbeing.',
        ),
      ],
    ),
  ),
  LearningArticle(
    id: 'anxiety',
    category: 'Understanding',
    title: 'Understanding anxiety',
    summary: 'Learn about worry, fear, and how anxiety may show up.',
    estimatedMinutes: 12,
    sections: [
      'Anxiety is a human response to uncertainty or perceived threat. For some people, it can become intense, frequent, or difficult to manage.',
      'Experiences vary. Some people notice racing thoughts, tension, restlessness, or changes in sleep. These experiences can have different causes and are not a diagnosis by themselves.',
      'A qualified professional can help you understand persistent or distressing symptoms and discuss appropriate support.',
    ],
    lessons: [
      CourseLesson(
        id: 'anx-1',
        title: 'Neurobiology of the Threat Response',
        content:
            'Anxiety is an evolutionary survival mechanism mediated by the brain\'s limbic system, primarily the amygdala. Upon detecting potential hazard, the autonomic nervous system triggers the sympathetic branch: adrenaline and noradrenaline surge, elevating heart rate, redirecting blood flow to major muscle groups, and causing hypervigilance.',
        keyTakeaways: [
          'The amygdala coordinates rapid involuntary defense responses',
          'Physical symptoms like elevated heart rate and sweating are somatic preparations for action',
          'Anxiety disorders arise when the threat alarm triggers without real danger',
        ],
      ),
      CourseLesson(
        id: 'anx-2',
        title: 'The Avoidance Paradox & Cognitive Spirals',
        content:
            'When an anxiety-provoking situation is avoided, discomfort drops immediately. This relief acts as a behavioral reward, signaling to the brain that the situation was indeed life-threatening. Cognitive distortions like catastrophizing ("If I fail, my life is ruined") and intolerance of uncertainty further magnify threat appraisal.',
        keyTakeaways: [
          'Avoidance yields immediate short-term relief at the cost of escalated long-term anxiety',
          'Catastrophizing exaggerates worst-case outcomes and minimizes personal resilience',
          'Systematic gradual exposure retrains neural circuitry to recognize safety',
        ],
      ),
      CourseLesson(
        id: 'anx-3',
        title: 'Somatic Down-Regulation & Grounding',
        content:
            'Because anxiety activates the sympathetic nervous system, physical regulation techniques can engage the parasympathetic "rest and digest" pathway. The physiological sigh (two brief nasal inhalations followed by a long, slow oral exhalation) increases intrathoracic pressure and signals the vagus nerve to decrease cardiac pacing.',
        keyTakeaways: [
          'The physiological sigh rapidly engages vagal parasympathetic braking',
          'Cognitive defusion encourages observing thoughts without treating them as facts',
          'Grounding through sensory input (5-4-3-2-1 technique) anchors attention in the present',
        ],
      ),
    ],
    quiz: CourseQuiz(
      questions: [
        QuizQuestion(
          question:
              'Which branch of the autonomic nervous system is responsible for the rapid heartbeat and adrenaline rush during acute anxiety?',
          options: [
            'Sympathetic nervous system',
            'Parasympathetic nervous system',
            'Enteric nervous system',
            'Somatic sensory system',
          ],
          correctIndex: 0,
          explanation:
              'The sympathetic nervous system activates the fight-or-flight response, accelerating pulse and respiration.',
        ),
        QuizQuestion(
          question: 'Why does habitual avoidance reinforce anxiety over the long term?',
          options: [
            'It physically damages the respiratory system',
            'It prevents the brain from learning that the feared situation is safe and tolerable',
            'It decreases muscle tone',
            'It eliminates all cortisol from the body',
          ],
          correctIndex: 1,
          explanation:
              'By avoiding the trigger, you never give your nervous system the chance to habituate and realize that the threat was benign.',
        ),
        QuizQuestion(
          question: 'What is the physiological sigh technique proven to accomplish?',
          options: [
            'It triggers an intense panic spike',
            'It rapidly activates parasympathetic vagal tone and lowers heart rate',
            'It increases blood pressure instantly',
            'It induces sudden unconsciousness',
          ],
          correctIndex: 1,
          explanation:
              'Two quick inhales followed by a prolonged exhale stimulate the vagus nerve to slow heart rate and somatic arousal.',
        ),
      ],
    ),
  ),
  LearningArticle(
    id: 'stress',
    category: 'Everyday wellbeing',
    title: 'Making sense of everyday stress',
    summary: 'A gentle introduction to stress and daily pressures.',
    estimatedMinutes: 8,
    sections: [
      'Stress can be a response to demands, uncertainty, or change. It may affect people emotionally, physically, and socially.',
      'There is no one-size-fits-all response to stress. What feels manageable for one person may feel overwhelming to another.',
      'If stress is affecting your safety, health, or ability to manage daily life, consider reaching out to a qualified professional or trusted support person.',
    ],
    lessons: [
      CourseLesson(
        id: 'str-1',
        title: 'Acute Mobilization vs. Allostatic Load',
        content:
            'Acute stress can be functional, sharpening attention and mobilizing physical resources for immediate deadlines. However, when stress is sustained without restorative recovery periods, the body enters a state of high allostatic load—the cumulative biological wear and tear on neuroendocrine, cardiovascular, and immune systems.',
        keyTakeaways: [
          'Acute stress is short-lived and adaptive; chronic unbuffered stress causes wear',
          'Allostatic load describes the systemic physiological cost of chronic stress',
          'Scheduled restorative intervals are necessary for biological balance',
        ],
      ),
      CourseLesson(
        id: 'str-2',
        title: 'Cognitive Appraisal & Coping Resources',
        content:
            'According to Lazarus and Folkman\'s Transactional Model, stress occurs when perceived environmental demands exceed perceived personal coping resources. Primary appraisal assesses potential harm or challenge; secondary appraisal evaluates what coping strategies are available. Reframing situations as challenges rather than threats mitigates harmful cardiovascular reactivity.',
        keyTakeaways: [
          'Subjective stress reflects the ratio of perceived demands to coping resources',
          'Reframing stressors as learning challenges reduces negative physiological impact',
          'Problem-focused and emotion-focused coping strategies serve distinct purposes',
        ],
      ),
      CourseLesson(
        id: 'str-3',
        title: 'Evidence-Based Resilience & Recovery',
        content:
            'In WHO\'s stress management framework "Doing What Matters in Times of Stress", resilience centers on psychological grounding, establishing values-based goals, practicing boundary setting, and safeguarding sleep. Learning to say no to non-essential commitments protects finite cognitive and emotional capacity.',
        keyTakeaways: [
          'Boundary setting preserves limited cognitive and physical bandwidth',
          'Sleep hygiene directly preserves prefrontal cortex regulatory functioning',
          'Regular micro-pauses during high-demand days prevent burnout accumulation',
        ],
      ),
    ],
    quiz: CourseQuiz(
      questions: [
        QuizQuestion(
          question: 'What term describes the cumulative biological wear and tear caused by prolonged, unmanaged stress?',
          options: ['Homeostatic baseline', 'Allostatic load', 'Cognitive dissonance', 'Metabolic latency'],
          correctIndex: 1,
          explanation:
              'Allostatic load refers to the cumulative bodily cost of maintaining chronic physiological stress responses.',
        ),
        QuizQuestion(
          question: 'According to Cognitive Appraisal Theory, when does an event become distressing?',
          options: [
            'Whenever the event takes place in the afternoon',
            'When perceived demands are assessed to exceed available coping resources',
            'Only if someone explicitly tells you to be stressed',
            'Whenever an alarm sounds',
          ],
          correctIndex: 1,
          explanation:
              'Stress emerges when an individual perceives that environmental demands surpass their ability to cope.',
        ),
        QuizQuestion(
          question: 'Which of the following is an evidence-based method to protect against chronic workplace burnout?',
          options: [
            'Skipping all meals and working without sleep',
            'Setting clear boundaries and scheduling restorative recovery intervals',
            'Taking on every single extra task requested by colleagues',
            'Refusing to ever speak with colleagues or friends',
          ],
          correctIndex: 1,
          explanation:
              'Consistent boundaries and intentional rest intervals allow the nervous system to return to baseline equilibrium.',
        ),
      ],
    ),
  ),
  LearningArticle(
    id: 'professional-help',
    category: 'Finding support',
    title: 'When to seek professional support',
    summary: 'Understand why and when talking to a qualified person may help.',
    estimatedMinutes: 10,
    sections: [
      'You do not need to wait until things feel unbearable to ask for support. It can be reasonable to speak with a qualified professional when something is worrying you or affecting everyday life.',
      'A health professional can listen, ask questions, and help you understand available options. You can ask about their qualifications, fees, confidentiality, and the kind of support they provide.',
      'If you or someone else may be in immediate danger, seek urgent in-person help from local emergency services or a trusted person. MindBridge is not monitored and cannot dispatch assistance.',
    ],
    lessons: [
      CourseLesson(
        id: 'pro-1',
        title: 'Recognizing Clinical Tipping Points',
        content:
            'While self-guided tools and lifestyle adjustments are valuable for mental fitness, they do not replace clinical healthcare. Clinical tipping points that signal the need for professional care include: symptoms lasting more than several weeks, marked difficulty fulfilling work or school duties, withdrawal from relationships, or persistent feelings of hopelessness.',
        keyTakeaways: [
          'Psychoeducation and apps are educational aids, not clinical treatments',
          'Functional impairment in daily life is a clear indicator for professional evaluation',
          'Seeking support early correlates with shorter recovery periods and better outcomes',
        ],
      ),
      CourseLesson(
        id: 'pro-2',
        title: 'Navigating Mental Health Professionals',
        content:
            'Healthcare systems provide different specialized roles. Psychiatrists are medical doctors who diagnose disorders and can prescribe medications. Clinical psychologists specialize in psychological testing and evidence-based psychotherapy (e.g., CBT, ACT, DBT). Licensed professional counselors, therapists, and clinical social workers provide structured talk therapy and crisis navigation.',
        keyTakeaways: [
          'Psychiatrists hold medical degrees and can prescribe psychiatric medications',
          'Psychologists and licensed therapists deliver evidence-based psychological therapies',
          'Stepped-care models frequently integrate both psychological and medical modalities',
        ],
      ),
      CourseLesson(
        id: 'pro-3',
        title: 'Confidentiality, Safety, & Emergency Helplines',
        content:
            'Professional therapy is protected by strict ethical confidentiality standards, broken only under narrow legal requirements regarding imminent danger to self or others. If anyone is in immediate physical danger or experiencing severe crisis, urgent emergency services or 24/7 crisis hotlines (such as 988 in the US/Canada or local equivalents) must be contacted immediately.',
        keyTakeaways: [
          'Therapeutic conversations are legally and ethically bound by confidentiality',
          'MindBridge is an offline, asynchronous tool and cannot dispatch crisis responders',
          'Live crisis hotlines and emergency departments provide immediate, real-time crisis care',
        ],
      ),
    ],
    quiz: CourseQuiz(
      questions: [
        QuizQuestion(
          question: 'Which mental health professional is a medical doctor authorized to prescribe medications?',
          options: ['Psychiatrist', 'Clinical Psychologist', 'Wellness Coach', 'Peer Mentor'],
          correctIndex: 0,
          explanation:
              'Psychiatrists are medical physicians who have completed medical school and residency in psychiatry.',
        ),
        QuizQuestion(
          question: 'What is the designated role of self-guided psychoeducation apps like MindBridge?',
          options: [
            'To replace licensed doctors and emergency medical services',
            'To provide educational literacy, reflection tools, and everyday coping strategies',
            'To prescribe pharmaceutical drug treatments',
            'To perform surgical and physical interventions',
          ],
          correctIndex: 1,
          explanation:
              'MindBridge is an evidence-based psychoeducation platform designed for learning and self-reflection, not clinical diagnosis.',
        ),
        QuizQuestion(
          question: 'What should someone do if they or someone else is in immediate, acute danger of harm?',
          options: [
            'Submit a question to an offline educational app and wait',
            'Call local emergency services (e.g. 911/112/999) or a 24/7 crisis helpline immediately',
            'Wait for several weeks to see if it improves on its own',
            'Read an online article about relaxation',
          ],
          correctIndex: 1,
          explanation:
              'Acute danger or emergency situations require immediate live human intervention through local emergency services or crisis lines.',
        ),
      ],
    ),
  ),
];
