import 'package:bootstrap/ui/views/cue_test/components/blur_focus_card.dart';
import 'package:bootstrap/ui/views/cue_test/components/counter_swap.dart';
import 'package:bootstrap/ui/views/cue_test/components/dialog_launcher.dart';
import 'package:bootstrap/ui/views/cue_test/components/entrance_stagger.dart';
import 'package:bootstrap/ui/views/cue_test/components/expandable_panel.dart';
import 'package:bootstrap/ui/views/cue_test/components/fab_radial_menu.dart';
import 'package:bootstrap/ui/views/cue_test/components/flip_card.dart';
import 'package:bootstrap/ui/views/cue_test/components/hover_card.dart';
import 'package:bootstrap/ui/views/cue_test/components/morph_box.dart';
import 'package:bootstrap/ui/views/cue_test/components/press_bounce_button.dart';
import 'package:bootstrap/ui/views/cue_test/components/pulse_loader.dart';
import 'package:bootstrap/ui/views/cue_test/components/scroll_reveal_row.dart';
import 'package:bootstrap/ui/views/cue_test/components/section_card.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'cue_test_viewmodel.dart';

class CueTestView extends StackedView<CueTestViewModel> {
  const CueTestView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CueTestViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cue Playground'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: const [
          SectionCard(
            title: '1. Entrada escalonada',
            description: 'Cue.onMount + Actors com delay crescente (stagger).',
            child: EntranceStagger(),
          ),
          SectionCard(
            title: '2. Botão com bounce',
            description: 'Cue.onToggle no estado pressionado + scale.',
            child: PressBounceButton(),
          ),
          SectionCard(
            title: '3. Painel expansível',
            description: 'Cue.onToggle + clipHeight + fade + ícone rotate.',
            child: ExpandablePanel(),
          ),
          SectionCard(
            title: '4. Menu FAB radial',
            description: 'Cue.onToggle + translate/scale/fade por item.',
            child: FabRadialMenu(),
          ),
          SectionCard(
            title: '5. Flip 3D',
            description: 'Cue.onToggle + flipY (rotação 3D no eixo Y).',
            child: FlipCard(),
          ),
          SectionCard(
            title: '6. Caixa que se transforma',
            description: 'decorate (cor/raio) + ScaleAct keyframed com bounce.',
            child: MorphBox(),
          ),
          SectionCard(
            title: '7. Foco / desfoque',
            description: 'Cue.onToggle + blur animado.',
            child: BlurFocusCard(),
          ),
          SectionCard(
            title: '8. Revelar ao rolar',
            description: 'Cue.onScrollVisible em lista horizontal.',
            child: ScrollRevealRow(),
          ),
          SectionCard(
            title: '9. Troca de número',
            description: 'Cue.onChange + fade + slide ao mudar o valor.',
            child: CounterSwap(),
          ),
          SectionCard(
            title: '10. Loader pulsante',
            description: 'Cue.onMount(repeat) com ping-pong — ótimo p/ splash.',
            child: PulseLoader(),
          ),
          SectionCard(
            title: '11. Diálogo animado',
            description: 'showCueDialog com Actor no conteúdo.',
            child: DialogLauncher(),
          ),
          SectionCard(
            title: '12. Hover (desktop/web)',
            description: 'Cue.onHover + scale + sombra.',
            child: HoverCard(),
          ),
        ],
      ),
    );
  }

  @override
  CueTestViewModel viewModelBuilder(BuildContext context) => CueTestViewModel();
}
