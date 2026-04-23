import 'package:flutter/material.dart';

import '../widgets/how_it_works_overlay.dart';
import 'download_success_page.dart';

class CaseSimulationPage extends StatelessWidget {
  const CaseSimulationPage({super.key});

  static const List<_CaseStep> _steps = [
    _CaseStep(
      index: 1,
      title: 'Introduction & context',
      subtitle: 'Set the stage for the case scenario',
      details: [
        _StepDetailBlock(
          title: 'Problem analysis',
          body:
              'Analyze underlying issues: potential depression diagnosis, social isolation following retirement, financial management difficulties, lack of structured daily routine.',
        ),
        _StepDetailBlock(
          title: 'Goal setting',
          body:
              'Collaborate with Maria to set SMART goals: reconnect with community activities, establish daily routine, address mental health needs, improve financial management.',
        ),
        _StepDetailBlock(
          title: 'Resource Mapping',
          body:
              'Identify available resources: community mental health services, local activity groups, financial counseling, volunteer visitor programs.',
        ),
      ],
    ),
    _CaseStep(
      index: 2,
      title: 'Assessment phase',
      subtitle: 'Gather and analyse relevant information',
      details: [
        _StepDetailBlock(
          title: 'Needs assessment',
          body:
              'Collect information about Maria\'s emotional wellbeing, social network, daily functioning, and practical challenges at home.',
        ),
        _StepDetailBlock(
          title: 'Risk and protective factors',
          body:
              'Map potential risks such as worsening isolation and low mood, while identifying strengths like motivation for change and existing support contacts.',
        ),
        _StepDetailBlock(
          title: 'Baseline documentation',
          body:
              'Record initial status indicators to compare progress over time: mood level, participation in activities, financial stress, and routine consistency.',
        ),
      ],
    ),
    _CaseStep(
      index: 3,
      title: 'Analysis & planning',
      subtitle: 'Develop intervention strategies',
      details: [
        _StepDetailBlock(
          title: 'Intervention strategy',
          body:
              'Select a balanced support approach combining psychosocial support, practical coaching, and community engagement pathways.',
        ),
        _StepDetailBlock(
          title: 'Scenario branching',
          body:
              'Prepare alternative plans for low-engagement and high-engagement responses so the support path can adapt quickly.',
        ),
        _StepDetailBlock(
          title: 'Success indicators',
          body:
              'Define measurable outcomes for this step: increased social contact, improved daily structure, and stabilized stress levels.',
        ),
      ],
    ),
    _CaseStep(
      index: 4,
      title: 'Intervention & implementation',
      subtitle: 'Execute the support plan',
      details: [
        _StepDetailBlock(
          title: 'Action rollout',
          body:
              'Start planned interventions in sequence: first routine-building, then social participation tasks, followed by targeted practical supports.',
        ),
        _StepDetailBlock(
          title: 'Communication plan',
          body:
              'Coordinate clear communication between Maria, case worker, and partner services to maintain alignment and accountability.',
        ),
        _StepDetailBlock(
          title: 'Real-time adjustments',
          body:
              'Monitor implementation barriers and make quick adjustments to intensity, pacing, or support channel when needed.',
        ),
      ],
    ),
    _CaseStep(
      index: 5,
      title: 'Monitoring & review',
      subtitle: 'Track progress and adjust as needed',
      details: [
        _StepDetailBlock(
          title: 'Progress tracking',
          body:
              'Review weekly indicators against baseline: emotional wellbeing, activity participation, practical stability, and confidence levels.',
        ),
        _StepDetailBlock(
          title: 'Reflection moments',
          body:
              'Facilitate structured reflection with Maria to identify what is working, what feels difficult, and what should be prioritized next.',
        ),
        _StepDetailBlock(
          title: 'Outcome review',
          body:
              'Assess progress toward SMART goals and decide whether to intensify support, maintain course, or transition to lighter follow-up.',
        ),
      ],
    ),
    _CaseStep(
      index: 6,
      title: 'Closure & transition',
      subtitle: 'Ensure sustainable outcomes',
      details: [
        _StepDetailBlock(
          title: 'Transition plan',
          body:
              'Create a structured step-down plan with clear responsibilities, timelines, and support contacts for the post-case period.',
        ),
        _StepDetailBlock(
          title: 'Sustainability supports',
          body:
              'Secure long-term community anchors, practical check-ins, and self-management tools that help maintain progress.',
        ),
        _StepDetailBlock(
          title: 'Follow-up schedule',
          body:
              'Set follow-up milestones and escalation triggers so emerging concerns can be addressed early and safely.',
        ),
      ],
    ),
  ];

  void _openStepOverlay(BuildContext context, _CaseStep step) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Step details',
      barrierColor: const Color(0xA6000000),
      transitionDuration: const Duration(milliseconds: 170),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _StepOverlayDialog(step: step);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(fade),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/app-background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.22, 0.22, 1],
                  colors: [
                    const Color(0xFFA66936).withValues(alpha: 0.60),
                    const Color(0xFFA66936).withValues(alpha: 0.60),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showHowItWorksOverlay(context),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _steps.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final step = _steps[index];
                                return _CaseStepCard(
                                  step: step,
                                  onTap: () => _openStepOverlay(context, step),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE02D91),
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: const Color(0x55000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Start case simulation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x45000000),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const DownloadSuccessPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE02D91),
                                  side: const BorderSide(
                                    color: Color(0xFFE02D91),
                                    width: 3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: const Color(0xFFF2F2F2),
                                ),
                                child: const Text(
                                  'Download case',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseStep {
  const _CaseStep({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  final int index;
  final String title;
  final String subtitle;
  final List<_StepDetailBlock> details;
}

class _CaseStepCard extends StatelessWidget {
  const _CaseStepCard({required this.step, required this.onTap});

  final _CaseStep step;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: const Color(0xFFA0BD00), width: 2.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x37000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFA0BD00),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    '${step.index}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 43,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: const TextStyle(
                        color: Color(0xFF141414),
                        fontWeight: FontWeight.w700,
                        fontSize: 16.8,
                        height: 1.04,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 12,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF7E7E7E),
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDetailBlock {
  const _StepDetailBlock({required this.title, required this.body});

  final String title;
  final String body;
}

class _StepOverlayDialog extends StatelessWidget {
  const _StepOverlayDialog({required this.step});

  final _CaseStep step;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 560, maxHeight: maxHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF5D5D5D),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x8A000000),
                      blurRadius: 8,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFF6F0F47),
                      width: 2.3,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  step.subtitle,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Color(0xFF454545),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFFE02D91),
                              size: 42,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              for (int i = 0; i < step.details.length; i++) ...[
                                _OverlayDetailCard(block: step.details[i]),
                                if (i != step.details.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE02D91),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shadowColor: const Color(0x55000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Regenerate this step',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x45000000),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE02D91),
                              side: const BorderSide(
                                color: Color(0xFFE02D91),
                                width: 3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: const Color(0xFFF2F2F2),
                            ),
                            child: const Text(
                              'Edit manually',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayDetailCard extends StatelessWidget {
  const _OverlayDetailCard({required this.block});

  final _StepDetailBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD7DCB1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  block.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              const Icon(Icons.edit_square, color: Color(0xFFA0BD00), size: 26),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            block.body,
            style: const TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 14,
              height: 1.22,
            ),
          ),
        ],
      ),
    );
  }
}
