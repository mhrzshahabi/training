package com.nicico.training.dto.question;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
public class QuestionAttachments  {
    List<Map<String, String>> files;
    List< Map<String, String>> option1Files;
    List< Map<String, String>> option2Files;
    List< Map<String, String>> option3Files;
    List< Map<String, String>> option4Files;
}
