# MindBridge Clinical Support Systems & Emergency Triage Research

## 1. Executive Summary & Clinical Duty of Care

A fundamental tenet of digital mental health (WHO mhGAP Intervention Guide, APA Division 12, and NICE guidelines) is that asynchronous, self-guided psychoeducation applications must maintain a rigorous safety architecture. Software applications are not monitored in real time and cannot dispatch emergency rescue services. Consequently, clear triage pathways and rapid access to accredited 24/7 crisis hotlines are required.

This document outlines the clinical evidence base, helpline accreditation, directory verification standards, and appointment preparation tools implemented within MindBridge's Support architecture.

---

## 2. Emergency Triage vs. Routine Psychoeducation

Clinical triage models categorize mental health needs into three distinct operational tiers:

```
+-------------------------------------------------------------------------+
| Tier 3: Acute Emergency / Crisis (Active suicidal ideation, psychosis,   |
|         severe agitation, acute physical danger)                        |
| -> Immediate Live Intervention: 988, 112, 999, Emergency Room           |
+-------------------------------------------------------------------------+
| Tier 2: Specialized Outpatient Clinical Care (Depression, GAD, PTSD,    |
|         functional impairment requiring diagnosis and psychotherapy)     |
| -> Licensed Psychologists, Psychiatrists, Clinical Social Workers       |
+-------------------------------------------------------------------------+
| Tier 1: Psychoeducation & Self-Guided Wellness (Stress, mild low mood,   |
|         routine mindfulness, emotional granularity reflection)          |
| -> MindBridge app: Reflection, Check-in, Curriculum, Breathing          |
+-------------------------------------------------------------------------+
```

MindBridge operates strictly within **Tier 1**. The Support tab bridges Tier 1 to Tier 2 and Tier 3 with utmost clarity and zero ambiguity.

---

## 3. Verified International & Regional Crisis Lifelines

All listed helplines meet primary-source verification criteria (toll-free or low-cost, confidential, 24/7, staffed by trained counselors):

### 3.1 North America (United States & Canada)
- **988 Suicide & Crisis Lifeline**:
  - Access: Call or text `988`
  - Hours: 24/7, 365 days a year
  - Scope: Free and confidential support for people in distress, prevention and crisis resources for loved ones.

### 3.2 United Kingdom
- **NHS 111 Mental Health Services**:
  - Access: Call `111` (select mental health option)
  - Scope: 24/7 clinical triage by trained mental health professionals.
- **Emergency**: `999` for life-threatening emergencies.

### 3.3 European Union
- **112 European Unified Emergency Number**:
  - Access: Call `112`
  - Scope: Free emergency access across all EU member states, routing directly to medical and psychological triage.

### 3.4 Nigeria & West Africa (Hausa & English)
- **112 Nigeria Emergency Services**:
  - Access: Call `112`
  - Scope: National emergency toll-free number.
- **Mentally Aware Nigeria Initiative (MANI)**:
  - Access: `+234 809 111 6264`
  - Scope: Leading youth-led mental health non-profit providing confidential crisis counseling.

### 3.5 Global Directory Navigation
- **Befrienders Worldwide** (`befrienders.org`): Emotional support across 32 countries.
- **International Association for Suicide Prevention (IASP)** (`iasp.info/resources/Crisis_Centres/`): Comprehensive directory of crisis centers in over 50 nations.

---

## 4. Provider Directory Accreditation Criteria

To prevent harm from unaccredited or predatory actors, MindBridge enforces a strict "Verification First" policy before listing individual practitioners:
1. **Primary Source License Verification**: Confirmation with national/regional licensing boards (e.g., State Medical Boards, HCPC, MDCN).
2. **Clinical Credential Review**: Graduate degrees in clinical psychology, medicine, or licensed counseling.
3. **Transparent Financial Disclosure**: Clear sliding-scale, private fee, or public healthcare coverage.
4. **Confidentiality Compliance**: Adherence to statutory privacy standards (HIPAA, GDPR, NDPR).

---

## 5. Appointment Preparation Checklist Methodology

Research from the American Psychological Association indicates that individuals attending initial therapy or psychiatric consultations often experience high anxiety and forget key questions.

MindBridge provides an interactive **Appointment Preparation Checklist** covering:
- **Licensing & Qualifications**: Inquiring about specialized training in CBT, ACT, or trauma.
- **Confidentiality & Privacy Boundaries**: Clarifying mandatory reporting exceptions and record-keeping.
- **Treatment Modalities**: Aligning client expectations with evidence-based interventions.
- **Fees & Sliding Scales**: Ensuring financial transparency upfront.

Responses and checked items are saved locally in `SharedPreferences` to empower users with confidence and agency during their healthcare visits.
