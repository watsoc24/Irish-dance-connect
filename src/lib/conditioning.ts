// Content for /practice/conditioning — light, beginner-safe exercises
// and stretches for young Irish dancers.
//
// Every exercise below is a generic, common-knowledge movement (calf
// raises, planks, ankle circles and so on) described in our own words.
// Nothing here reproduces any trainer's routine, programme or wording.
// Established trainers and programmes are linked out to their official
// sites only, in TRAINER_LINKS, so families can explore the real thing
// directly with them.

export interface ConditioningExercise {
  name: string;
  /** Plain-language how-to, in our own words. */
  howTo: string;
  /** A light, beginner dose: reps, sets or seconds. */
  dose: string;
  /** One form point to keep the movement safe and honest. */
  watchFor: string;
}

export interface ConditioningGroup {
  slug: string;
  name: string;
  intro: string;
  exercises: ConditioningExercise[];
}

export const CONDITIONING_GROUPS: ConditioningGroup[] = [
  {
    slug: "ankles-calves",
    name: "Ankles & calves",
    intro:
      "Irish dancers spend so much time up on their toes that strong calves and mobile, steady ankles are the foundation of everything — height in jumps, control in soft shoe, and soft, quiet landings in hard shoe.",
    exercises: [
      {
        name: "Calf raises",
        howTo:
          "Stand tall with your feet hip-width apart, resting your fingertips lightly on a wall or the back of a chair for balance. Press through the balls of your feet to lift your heels as high as is comfortable, pause for a moment at the top, then lower slowly back down.",
        dose: "2 sets of 10, slow and controlled",
        watchFor: "Keep your ankles straight as you rise — don't let them roll inwards or outwards.",
      },
      {
        name: "Single-leg calf raises",
        howTo:
          "Hold a wall or chair and lift one foot slightly off the floor behind you. Using only the standing leg, press through the ball of the foot to raise your heel, pause at the top, and lower slowly. Swap legs after each set.",
        dose: "2 sets of 6–8 on each leg",
        watchFor: "A little wobble is normal — keep a fingertip on the support so a wobble never becomes a fall.",
      },
      {
        name: "Ankle circles",
        howTo:
          "Sit down, or stand holding a support, and lift one foot just off the floor. Draw a slow, smooth circle with your toes, as if you were stirring a big pot. Circle in both directions, then swap feet.",
        dose: "5 circles each way, on each foot",
        watchFor: "Keep the movement in the ankle — your knee and lower leg stay still.",
      },
      {
        name: "Towel scrunches",
        howTo:
          "Sit on a chair with a small towel spread flat on the floor under one bare foot. Use your toes to scrunch the towel towards you, then smooth it back out and repeat. Swap feet after each set.",
        dose: "About 30 seconds on each foot, twice",
        watchFor: "If your foot cramps, shake it out, rest for a moment, and carry on more gently.",
      },
    ],
  },
  {
    slug: "hips-turnout",
    name: "Hips & turnout",
    intro:
      "Turnout is rotation that happens at the hip joint, powered by the deep hip and glute muscles. These exercises wake those muscles up. Never make turnout by twisting your knees or screwing your feet into the floor — that strains joints instead of building strength, and it never lasts.",
    exercises: [
      {
        name: "Clamshells",
        howTo:
          "Lie on your side with your knees bent and your feet in line with your back, resting your head on your lower arm. Keeping your feet together, lift the top knee open like the cover of a book, only as far as you can go without your hips rolling back. Lower slowly.",
        dose: "2 sets of 8 on each side",
        watchFor: "Your pelvis stays still — if your whole body rolls backwards, open the knee a little less.",
      },
      {
        name: "Glute bridges",
        howTo:
          "Lie on your back with your knees bent, feet flat on the floor and arms resting by your sides. Press through your heels to lift your hips until your body makes one straight line from shoulders to knees, squeeze your glutes at the top, then lower slowly.",
        dose: "2 sets of 10",
        watchFor: "Lift with your glutes and the backs of your thighs, not by arching your lower back.",
      },
      {
        name: "Standing hip openers",
        howTo:
          "Stand tall, holding a support. Lift one knee up in front of you to about hip height, then slowly carry the knee out to the side, like opening a gate, and lower the foot back down. Swap legs after each set.",
        dose: "6 on each leg, twice through",
        watchFor: "Keep your shoulders and standing hip facing forwards — all the movement happens in the lifted leg's hip.",
      },
      {
        name: "Turnout holds",
        howTo:
          "Stand with your heels together in a small first position. Gently rotate both legs from the hips so your toes point a little further apart — only as far as your hips can honestly do the work — and hold the position while breathing normally. Release, rest, and repeat.",
        dose: "Hold 10–15 seconds, 4 times",
        watchFor: "If your knees twist or your feet grip the floor to force a bigger angle, you have gone too far — ease back.",
      },
    ],
  },
  {
    slug: "core-posture",
    name: "Core & posture",
    intro:
      "A strong, steady trunk is what lets an Irish dancer keep the upper body quiet and the arms still while the feet do fast, powerful work underneath. These exercises build that steadiness without any equipment.",
    exercises: [
      {
        name: "Dead bug",
        howTo:
          "Lie on your back with your arms pointing up at the ceiling and your knees bent above your hips, shins level with the floor. Slowly lower one arm overhead while the opposite foot reaches towards the floor, then bring both back and swap sides. Make the movement smaller if your back starts to arch.",
        dose: "6 slow reps on each side",
        watchFor: "Your lower back stays gently pressed towards the floor for the whole exercise.",
      },
      {
        name: "Bird dog",
        howTo:
          "Start on your hands and knees with your back flat, like a tabletop. Slide one foot back until that leg is straight behind you while the opposite arm reaches forwards. Hold for a moment, return to the start, and swap sides.",
        dose: "6 on each side, holding 3 seconds each",
        watchFor: "Imagine balancing a cup of water on your lower back — your hips stay level, with no tipping side to side.",
      },
      {
        name: "Front plank",
        howTo:
          "Lie face down, then prop yourself up on your forearms and your knees — or your toes, if that feels comfortable — so your body forms one straight line from your head to your knees. Pull your tummy in gently and breathe steadily while you hold.",
        dose: "3 holds of 15–20 seconds",
        watchFor: "Don't let your hips sag or your bottom stick up in the air — a shorter, tidy hold is better than a long, saggy one.",
      },
      {
        name: "Shoulder blade squeezes",
        howTo:
          "Stand or sit tall with your arms relaxed at your sides. Gently draw your shoulder blades together and slightly down, as if tucking them into your back pockets. Hold for a few seconds, then let go.",
        dose: "2 sets of 8, holding 3 seconds each",
        watchFor: "The shoulders move down and back — don't shrug them up towards your ears.",
      },
    ],
  },
  {
    slug: "balance-control",
    name: "Balance & control",
    intro:
      "Balance is a skill of its own, and it underpins everything from slow, controlled soft-shoe work to sticking a landing in hard shoe. Practise these near a wall or a chair so support is always within reach.",
    exercises: [
      {
        name: "Single-leg stand",
        howTo:
          "Stand tall near a wall and lift one foot just off the floor, keeping the standing knee soft rather than locked. Fix your eyes on one still spot ahead of you and balance. Swap legs after each hold.",
        dose: "3 holds of 20–30 seconds on each leg",
        watchFor: "Stay tall through the standing leg — don't sink into the hip or lean your trunk to one side.",
      },
      {
        name: "Clock taps",
        howTo:
          "Balance on one leg. Keeping all your weight on that leg, tap the other foot lightly on the floor in front of you, then out to the side, then behind you — like touching 12, 3 and 6 on a clock face. Come back to the middle between taps.",
        dose: "4 rounds on each leg",
        watchFor: "The taps are feather-light — the standing leg does all the work, not the tapping foot.",
      },
      {
        name: "Tandem walk",
        howTo:
          "Walk slowly along a line on the floor, placing each foot directly in front of the other so the heel of the front foot touches the toes of the foot behind. Take your time, and keep a wall nearby if you need it at first.",
        dose: "8–10 slow steps forwards, twice — walk back normally",
        watchFor: "Look ahead at a fixed point rather than down at your feet.",
      },
      {
        name: "Single-leg mini knee bend",
        howTo:
          "Holding a support, stand on one leg and bend the standing knee by a small amount — just a few centimetres — keeping the knee pointing over your toes, then straighten again. Move slowly, as if doing a tiny, controlled dip.",
        dose: "2 sets of 6 on each leg",
        watchFor: "The knee tracks over the second toe and never caves inwards.",
      },
    ],
  },
  {
    slug: "cool-down-stretches",
    name: "Cool-down stretches",
    intro:
      "Stretch only when your muscles are warm — after class, after practice, or after the exercises above — never on cold muscles. Every stretch should feel like a gentle pull, never pain. Breathe slowly, ease into each one, and never bounce.",
    exercises: [
      {
        name: "Standing calf stretch",
        howTo:
          "Stand facing a wall with both hands on it. Step one foot back, keeping that leg straight and its heel pressed into the floor, and bend the front knee until you feel a gentle stretch in the back calf. Hold, then swap sides.",
        dose: "20–30 seconds on each side, twice",
        watchFor: "Keep the back heel down and the toes pointing forwards — if the heel lifts, bring the foot a little closer to the wall.",
      },
      {
        name: "Hamstring stretch",
        howTo:
          "Place one heel on the floor a step in front of you, toes pointing up. Keeping your back flat and your chest lifted, hinge gently forwards from the hips until you feel a stretch down the back of that thigh. Hold, then swap sides.",
        dose: "20–30 seconds on each side, twice",
        watchFor: "Hinge from the hips with a flat back — don't round your spine or try to force your hands to the floor.",
      },
      {
        name: "Figure-four hip stretch",
        howTo:
          "Lie on your back with both knees bent and feet flat. Cross one ankle over the opposite knee, then gently draw both legs in towards you until you feel a stretch in the hip and glute of the crossed leg. Hold, then swap sides.",
        dose: "20–30 seconds on each side, twice",
        watchFor: "You should feel a gentle pull in the hip — stop straight away if you feel pinching in the knee.",
      },
    ],
  },
];

export interface TrainerLink {
  name: string;
  url: string;
  /** One original sentence on what they offer. */
  blurb: string;
}

// Established Irish dance conditioning professionals, linked out to
// their official sites only. Each URL was fetched and confirmed as the
// programme's official home on Nov 19, 2026. These are their own paid,
// professional programmes — nothing of theirs is reproduced here, and
// Irish Dance Connect is not affiliated with any of them.
export const TRAINER_LINKS: TrainerLink[] = [
  {
    name: "Target Training",
    url: "https://www.targettrainingdance.com",
    blurb:
      "Irish dance-specific strength and conditioning, with live online classes such as the 10 Week Workout and an on-demand training library for dancers who want a structured programme to follow.",
  },
  {
    name: "The Performance Project",
    url: "https://performanceprojectdance.com",
    blurb:
      "Frances Dunne's platform for the Irish dance community, offering workshops and training programmes covering strength, flexibility and complete performance development.",
  },
  {
    name: "From Head to Toe Academy",
    url: "https://fromheadtotoeacademy.com",
    blurb:
      "A membership academy for Irish dancers covering strength and conditioning, mobility, nutrition and mindset, taught by a team of professional coaches that includes Frances Dunne.",
  },
  {
    name: "Feis Fit",
    url: "https://www.areyoufeisfit.com",
    blurb:
      "One-to-one coaching for Irish dancers, building personalised strength and stamina programmes with certified trainers who have competed at championship level themselves.",
  },
];
