class FastingMilestone {
  final Duration duration;
  final String title;
  final String description;
  final List<String> benefits;
  final List<BodySystem> affectedSystems;

  const FastingMilestone({
    required this.duration,
    required this.title,
    required this.description,
    required this.benefits,
    required this.affectedSystems,
  });

  double get hours => duration.inHours + (duration.inMinutes % 60) / 60.0;
}

enum BodySystem {
  brain('Cérebro', 'Sistema Nervoso'),
  liver('Fígado', 'Sistema Digestivo'),
  muscles('Músculos', 'Sistema Muscular'),
  fat('Tecido Adiposo', 'Reserva de Energia'),
  heart('Coração', 'Sistema Cardiovascular'),
  cells('Células', 'Nível Celular'),
  immune('Sistema Imune', 'Imunidade'),
  gut('Intestino', 'Sistema Digestivo');

  final String name;
  final String category;

  const BodySystem(this.name, this.category);
}

class FastingTimeline {
  static const List<FastingMilestone> milestones = [
    FastingMilestone(
      duration: Duration(hours: 12),
      title: 'Jejum Inicial',
      description: 'Seu corpo começa a transição para o estado de jejum',
      benefits: [
        'Diminuição dos níveis de insulina',
        'Início da queima de gordura',
        'Melhora na sensibilidade à insulina',
      ],
      affectedSystems: [BodySystem.liver, BodySystem.fat],
    ),
    FastingMilestone(
      duration: Duration(hours: 14),
      title: 'Queima de Gordura Acelerada',
      description: 'O corpo aumenta significativamente a oxidação de gorduras',
      benefits: [
        'Aumento da queima de gordura em 30-40%',
        'Redução do apetite',
        'Estabilização dos níveis de energia',
      ],
      affectedSystems: [BodySystem.fat, BodySystem.brain],
    ),
    FastingMilestone(
      duration: Duration(hours: 16),
      title: 'Autofagia Inicial',
      description: 'Processo de limpeza celular começa a se intensificar',
      benefits: [
        'Início significativo da autofagia',
        'Renovação de componentes celulares danificados',
        'Redução da inflamação celular',
        'Proteção contra doenças neurodegenerativas',
      ],
      affectedSystems: [BodySystem.cells, BodySystem.brain, BodySystem.immune],
    ),
    FastingMilestone(
      duration: Duration(hours: 18),
      title: 'Autofagia Intensificada',
      description: 'Processo de reciclagem celular em alta atividade',
      benefits: [
        'Autofagia em níveis elevados',
        'Remoção de proteínas defeituosas',
        'Regeneração de células do sistema imune',
        'Melhora da função mitocondrial',
      ],
      affectedSystems: [BodySystem.cells, BodySystem.immune, BodySystem.liver],
    ),
    FastingMilestone(
      duration: Duration(hours: 20),
      title: 'Regeneração Profunda',
      description: 'Benefícios metabólicos e cognitivos avançados',
      benefits: [
        'Aumento do BDNF (fator neurotrófico)',
        'Melhora da clareza mental e foco',
        'Redução significativa da inflamação',
        'Otimização da sensibilidade à insulina',
      ],
      affectedSystems: [BodySystem.brain, BodySystem.cells, BodySystem.heart],
    ),
    FastingMilestone(
      duration: Duration(hours: 24),
      title: 'Reset Metabólico Completo',
      description: 'Um dia completo de jejum traz transformações profundas',
      benefits: [
        'Autofagia máxima em múltiplos órgãos',
        'Redução de triglicerídeos no sangue',
        'Aumento do hormônio do crescimento (HGH)',
        'Ativação de células-tronco neurais',
        'Desinflamação sistêmica',
      ],
      affectedSystems: [
        BodySystem.brain,
        BodySystem.liver,
        BodySystem.heart,
        BodySystem.cells,
        BodySystem.immune,
      ],
    ),
    FastingMilestone(
      duration: Duration(hours: 36),
      title: 'Limpeza Celular Avançada',
      description: 'Jejum prolongado ativa mecanismos de reparo profundos',
      benefits: [
        'Autofagia em nível máximo',
        'Redução drástica da glicose e insulina',
        'Aumento expressivo do HGH (até 300%)',
        'Queima intensa de gordura visceral',
        'Regeneração do sistema digestivo',
      ],
      affectedSystems: [
        BodySystem.cells,
        BodySystem.gut,
        BodySystem.fat,
        BodySystem.muscles,
      ],
    ),
    FastingMilestone(
      duration: Duration(hours: 48),
      title: 'Renovação do Sistema Imune',
      description: 'Dois dias de jejum promovem regeneração imunológica',
      benefits: [
        'Reciclagem de células imunes antigas',
        'Produção de novas células de defesa',
        'Redução de marcadores inflamatórios',
        'Melhora da resistência à insulina',
        'Proteção cardiovascular avançada',
      ],
      affectedSystems: [
        BodySystem.immune,
        BodySystem.heart,
        BodySystem.cells,
        BodySystem.liver,
      ],
    ),
    FastingMilestone(
      duration: Duration(hours: 72),
      title: 'Rejuvenescimento Celular',
      description: 'Três dias ativam poderosos mecanismos anti-envelhecimento',
      benefits: [
        'Ativação profunda de células-tronco',
        'Regeneração do sistema imunológico',
        'Redução do risco de doenças crônicas',
        'Otimização metabólica completa',
        'Proteção neurodegenerativa máxima',
      ],
      affectedSystems: [
        BodySystem.cells,
        BodySystem.immune,
        BodySystem.brain,
        BodySystem.heart,
        BodySystem.liver,
      ],
    ),
    FastingMilestone(
      duration: Duration(days: 4),
      title: 'Transformação Metabólica',
      description: 'Quatro dias de jejum promovem mudanças estruturais',
      benefits: [
        'Reprogramação metabólica completa',
        'Eliminação de células senescentes',
        'Otimização da função mitocondrial',
        'Redução do estresse oxidativo',
        'Melhora da saúde cardiovascular',
      ],
      affectedSystems: [
        BodySystem.cells,
        BodySystem.heart,
        BodySystem.fat,
        BodySystem.muscles,
        BodySystem.brain,
      ],
    ),
    FastingMilestone(
      duration: Duration(days: 5),
      title: 'Renovação Total',
      description: 'Cinco dias completam o ciclo de regeneração profunda',
      benefits: [
        'Regeneração máxima de células-tronco',
        'Sistema imune completamente renovado',
        'Perfil lipídico otimizado',
        'Controle glicêmico excelente',
        'Proteção contra envelhecimento acelerado',
        'Clareza mental excepcional',
      ],
      affectedSystems: [
        BodySystem.cells,
        BodySystem.immune,
        BodySystem.brain,
        BodySystem.heart,
        BodySystem.liver,
        BodySystem.gut,
        BodySystem.fat,
      ],
    ),
  ];

  static FastingMilestone? getMilestoneForDuration(Duration elapsed) {
    FastingMilestone? currentMilestone;
    
    for (var milestone in milestones) {
      if (elapsed >= milestone.duration) {
        currentMilestone = milestone;
      } else {
        break;
      }
    }
    
    return currentMilestone;
  }

  static List<FastingMilestone> getAchievedMilestones(Duration elapsed) {
    return milestones.where((m) => elapsed >= m.duration).toList();
  }

  static double getProgress(Duration elapsed, Duration target) {
    if (elapsed >= target) return 1.0;
    return elapsed.inMinutes / target.inMinutes;
  }
}
