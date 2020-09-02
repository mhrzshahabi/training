package com.nicico.training.utility;

public class PersianCharachtersUnicode {
    char c;
    private String InitialFom_Unicode;
    private String MedialForm_Unicode;
    private String FinalForm_Unicode;
    private String IsolatedForm_Unicode;
    private boolean nextInitial;


    public void setCharc (char c) {
        this.c = c;
        calculate();
    }


    private void calculate() {

        switch (c) {

            case 'آ':

                InitialFom_Unicode    = "ﺁ";
                MedialForm_Unicode    = "ﺂ";
                FinalForm_Unicode     = "ﺁ";
                IsolatedForm_Unicode  = "ﺁ";
//                nextInitial = false;
                break;

            case 'ا':

                InitialFom_Unicode    = "ا";
                MedialForm_Unicode    = "ﺎ";
                FinalForm_Unicode     = "ا";
                IsolatedForm_Unicode  = "ا";
//                nextInitial = false;
                break;


            case 'ب':

                InitialFom_Unicode    = "ﺑ";
                MedialForm_Unicode    = "ﺒ";
                FinalForm_Unicode     = "ﺐ";
                IsolatedForm_Unicode  = "ب";
//                nextInitial = false;
                break;


            case 'پ':

                InitialFom_Unicode    = "ﭘ";
                MedialForm_Unicode    = "ﭙ";
                FinalForm_Unicode     = "ﭗ";
                IsolatedForm_Unicode  = "پ";
//                nextInitial = false;
                break;


            case 'ت':

                InitialFom_Unicode    = "ﺗ";
                MedialForm_Unicode    = "ﺘ";
                FinalForm_Unicode     = "ﺖ";
                IsolatedForm_Unicode  = "ت";
//                nextInitial = false;
                break;


            case 'ث':

                InitialFom_Unicode    = "ﺛ";
                MedialForm_Unicode    = "ﺜ";
                FinalForm_Unicode     = "ﺚ";
                IsolatedForm_Unicode  = "ث";
//                nextInitial = false;
                break;


            case 'ج':

                InitialFom_Unicode    = "ﺟ";
                MedialForm_Unicode    = "ﺠ";
                FinalForm_Unicode     = "ﺞ";
                IsolatedForm_Unicode  = "ج";
//                nextInitial = false;
                break;


            case 'چ':

                InitialFom_Unicode    = "ﭼ";
                MedialForm_Unicode    = "ﭽ";
                FinalForm_Unicode     = "ﭻ";
                IsolatedForm_Unicode  = "چ";
//                nextInitial = false;
                break;


            case 'ح':

                InitialFom_Unicode    = "ﺣ";
                MedialForm_Unicode    = "ﺤ";
                FinalForm_Unicode     = "ﺢ";
                IsolatedForm_Unicode  = "ح";
//                nextInitial = false;
                break;


            case 'خ':

                InitialFom_Unicode    = "ﺧ";
                MedialForm_Unicode    = "ﺨ";
                FinalForm_Unicode     = "ﺦ";
                IsolatedForm_Unicode  = "خ";
//                nextInitial = false;
                break;


            case 'د':

                InitialFom_Unicode    = "ﺩ";
                MedialForm_Unicode    = "ﺪ";
                FinalForm_Unicode     = "ﺪ";
                IsolatedForm_Unicode  = "د";
//                nextInitial = true;
                break;


            case 'ذ':

                InitialFom_Unicode    = "ذ";
                MedialForm_Unicode    = "ﺬ";
                FinalForm_Unicode     = "ﺬ";
                IsolatedForm_Unicode  = "ذ";
//                nextInitial = true;
                break;


            case 'ر':

                InitialFom_Unicode    = "ر";
                MedialForm_Unicode    = "ﺮ";
                FinalForm_Unicode     = "ﺮ";
                IsolatedForm_Unicode  = "ر";
//                nextInitial = true;
                break;


            case 'ز':

                InitialFom_Unicode    = "ز";
                MedialForm_Unicode    = "ﺰ";
                FinalForm_Unicode     = "ﺰ";
                IsolatedForm_Unicode  = "ز";
//                nextInitial = true;
                break;


            case 'ژ':

                InitialFom_Unicode    = "ژ";
                MedialForm_Unicode    = "ﮋ";
                FinalForm_Unicode     = "ﮋ";
                IsolatedForm_Unicode  = "ژ";
//                nextInitial = true;
                break;


            case 'س':

                InitialFom_Unicode    = "ﺳ";
                MedialForm_Unicode    = "ﺴ";
                FinalForm_Unicode     = "ﺲ";
                IsolatedForm_Unicode  = "س";
//                nextInitial = false;
                break;


            case 'ش':

                InitialFom_Unicode    = "ﺷ";
                MedialForm_Unicode    = "ﺸ";
                FinalForm_Unicode     = "ﺶ";
                IsolatedForm_Unicode  = "ش";
//                nextInitial = false;
                break;


            case 'ص':

                InitialFom_Unicode    = "ﺻ";
                MedialForm_Unicode    = "ﺼ";
                FinalForm_Unicode     = "ﺺ";
                IsolatedForm_Unicode  = "ص";
//                nextInitial = false;
                break;


            case 'ض':

                InitialFom_Unicode    = "ﺿ";
                MedialForm_Unicode    = "ﻀ";
                FinalForm_Unicode     = "ﺾ";
                IsolatedForm_Unicode  = "ض";
//                nextInitial = false;
                break;


            case 'ط':

                InitialFom_Unicode    = "ﻃ";
                MedialForm_Unicode    = "ﻄ";
                FinalForm_Unicode     = "ﻂ";
                IsolatedForm_Unicode  = "ط";
//                nextInitial = false;
                break;


            case 'ظ':

                InitialFom_Unicode    = "ﻇ";
                MedialForm_Unicode    = "ﻈ";
                FinalForm_Unicode     = "ﻆ";
                IsolatedForm_Unicode  = "ظ";
//                nextInitial = false;
                break;


            case 'ع':

                InitialFom_Unicode    = "ﻋ";
                MedialForm_Unicode    = "ﻌ";
                FinalForm_Unicode     = "ﻊ";
                IsolatedForm_Unicode  = "ع";
//                nextInitial = false;
                break;


            case 'غ':

                InitialFom_Unicode    = "ﻏ";
                MedialForm_Unicode    = "ﻐ";
                FinalForm_Unicode     = "ﻎ";
                IsolatedForm_Unicode  = "غ";
//                nextInitial = false;
                break;


            case 'ف':

                InitialFom_Unicode    = "ﻓ";
                MedialForm_Unicode    = "ﻔ";
                FinalForm_Unicode     = "ﻒ";
                IsolatedForm_Unicode  = "ف";
//                nextInitial = false;
                break;


            case 'ق':

                InitialFom_Unicode    = "ﻗ";
                MedialForm_Unicode    = "ﻘ";
                FinalForm_Unicode     = "ﻖ";
                IsolatedForm_Unicode  = "ق";
//                nextInitial = false;
                break;


            case 'ک':

                InitialFom_Unicode    = "ﮐ";
                MedialForm_Unicode    = "ﮑ";
                FinalForm_Unicode     = "ﮏ";
                IsolatedForm_Unicode  = "ک";
//                nextInitial = false;
                break;


            case 'گ':

                InitialFom_Unicode    = "ﮔ";
                MedialForm_Unicode    = "ﮕ";
                FinalForm_Unicode     = "ﮓ";
                IsolatedForm_Unicode  = "گ";
//                nextInitial = false;
                break;


            case 'ل':

                InitialFom_Unicode    = "ﻟ";
                MedialForm_Unicode    = "ﻠ";
                FinalForm_Unicode     = "ﻞ";
                IsolatedForm_Unicode  = "ل";
//                nextInitial = false;
                break;


            case 'م':

                InitialFom_Unicode    = "ﻣ";
                MedialForm_Unicode    = "ﻤ";
                FinalForm_Unicode     = "ﻢ";
                IsolatedForm_Unicode  = "م";
//                nextInitial = false;
                break;


            case 'ن':

                InitialFom_Unicode    = "ﻧ";
                MedialForm_Unicode    = "ﻨ";
                FinalForm_Unicode     = "ﻦ";
                IsolatedForm_Unicode  = "ن";
//                nextInitial = false;
                break;


            case 'و':

                InitialFom_Unicode    = "ﻭ";
                MedialForm_Unicode    = "ﻮ";
                FinalForm_Unicode     = "ﻮ";
                IsolatedForm_Unicode  = "و";
//                nextInitial = true;
                break;


            case 'ه':

                InitialFom_Unicode    = "ﻫ";
                MedialForm_Unicode    = "ﻬ";
                FinalForm_Unicode     = "ﻪ";
                IsolatedForm_Unicode  = "ه";
//                nextInitial = false;
                break;


            case 'ی':

                InitialFom_Unicode    = "ﯾ";
                MedialForm_Unicode    = "ﯿ";
                FinalForm_Unicode     = "ﯽ";
                IsolatedForm_Unicode  = "ﯼ";
//                nextInitial = false;
                break;

            case 'ة':

                InitialFom_Unicode    = String.valueOf(c);
                MedialForm_Unicode    = String.valueOf(c);
                FinalForm_Unicode     = "ﺔ";
                IsolatedForm_Unicode  = "ﺓ";
//                nextInitial = false;
                break;

            case 'ي':

                InitialFom_Unicode    = "ﻳ";
                MedialForm_Unicode    = "ﻴ";
                FinalForm_Unicode     = "ﻲ";
                IsolatedForm_Unicode  = "ﯼ";
//                nextInitial = false;
                break;

            case ')':

                InitialFom_Unicode    = "(";
                MedialForm_Unicode    = "(";
                FinalForm_Unicode     = "(";
                IsolatedForm_Unicode  = "(";
//                nextInitial = false;
                break;

            case '(':

                InitialFom_Unicode    = ")";
                MedialForm_Unicode    = ")";
                FinalForm_Unicode     = ")";
                IsolatedForm_Unicode  = ")";
//                nextInitial = false;
                break;


            default:
                InitialFom_Unicode    = String.valueOf(c);//String.format("\\u%04x", (int) c);
                MedialForm_Unicode    = String.valueOf(c);//String.format("\\u%04x", (int) c);
                FinalForm_Unicode     = String.valueOf(c);//String.format("\\u%04x", (int) c);
                IsolatedForm_Unicode  = String.valueOf(c);//String.format("\\u%04x", (int) c);
//                nextInitial = true;
                break;
        }

    }




    /**
     * @return the initialFom_Unicode
     */
    public String getInitialFom_Unicode() {
        return InitialFom_Unicode;
    }

    /**
     * @return the finalForm_Unicode
     */
    public String getFinalForm_Unicode() {
        return FinalForm_Unicode;
    }

    /**
     * @return the isolatedForm_Unicode
     */
    public String getIsolatedForm_Unicode() {
        return IsolatedForm_Unicode;
    }

    /**
     * @return the medialForm_Unicode
     */
    public String getMedialForm_Unicode() {
        return MedialForm_Unicode;
    }

    /**
     * @return the nextInitial
     */
    public static Boolean getNextInitial(char c) {
        boolean init = false;
        switch (c) {
            case 'د':
                init = true;
            break;
            case 'ذ':
                init = true;
                break;
            case 'ر':
                init = true;
                break;
            case 'ز':
                init = true;
                break;
            case 'ژ':
                init = true;
                break;
            case 'و':
                init = true;
                break;
            case ' ':
                init = true;
                break;
            case 'ا':
                init = true;
                break;
            case '(':
                init = true;
                break;
            case ')':
                init = true;
                break;
            default:
                init = false;
                break;
        }
        return init;
    }

    /**
     * @return the حقثرInitial
     */
    public static Boolean getPrevInitial(char c) {
        boolean init = false;
        switch (c) {
            case ' ':
                init = true;
                break;
            case '(':
                init = true;
                break;
            case ')':
                init = true;
                break;
            default:
                init = false;
                break;
        }
        return init;
    }
}

