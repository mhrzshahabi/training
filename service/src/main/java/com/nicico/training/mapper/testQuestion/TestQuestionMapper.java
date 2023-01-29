package com.nicico.training.mapper.testQuestion;

import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.TestQuestion;
import dto.exam.ElsExamCreateDTO;
import dto.exam.ElsImportedExam;
import dto.exam.ExamNotSentToElsDTO;
import dto.exam.ExamType;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TestQuestionMapper {
    @Autowired
    protected ITestQuestionService iTestQuestionService;
    @Mappings({
            @Mapping(target = "date", source = "startDate"),
            @Mapping(target = "time", source = "startTime"),
            @Mapping(target = "classCode", source = "examCode")
    })
   public abstract TestQuestionDTO.Import toTestQuestionDto(ElsImportedExam elsImportedExam);

    @Mappings({
            @Mapping(target = "startDate", source = "date"),
            @Mapping(target = "startTime", source = "time"),
            @Mapping(target = "sourceExamId", source = "id")
    })
    public abstract ElsExamCreateDTO.Info toInfo(TestQuestionDTO.Info info);

    @Mappings({
            @Mapping(target = "startDate", source = "date"),
            @Mapping(target = "startTime", source = "time"),
            @Mapping(target = "sourceExamId", source = "id")
    })
    public abstract  ElsExamCreateDTO.Info toInfo(TestQuestion testQuestion);

    public abstract  TestQuestionDTO.Create toCreate(TestQuestionDTO.Import dto);

    @Mappings({
            @Mapping(target = "name", source = "tclass.titleClass"),
            @Mapping(target = "type", source = "id", qualifiedByName = "getExamTypeByTestQuestionId"),
            @Mapping(target = "acceptanceLimit", source = "tclass.acceptancelimit", qualifiedByName = "convertAcceptanceLimit")
    })
    public abstract ExamNotSentToElsDTO.Info toExamNotSentDto(TestQuestion testQuestion);

    public abstract  List<ExamNotSentToElsDTO.Info> toExamNotSentDto(List<TestQuestion> testQuestions);


    @Named("getExamTypeByTestQuestionId")
     ExamType getExamTypeByTestQuestionId(Long testQuestionId ) {
        Set<QuestionBankDTO.Exam> testQuestionBanks = iTestQuestionService.getAllQuestionsByTestQuestionId(testQuestionId);

        int multies = 0;
        int descriptive = 0;

        for (QuestionBankDTO.Exam question : testQuestionBanks) {
            if (question.getQuestionType().getCode().equals("Descriptive"))
                descriptive++;
            else
                multies++;


        }
        if (multies > 0 && descriptive > 0)
            return ExamType.MIX;
        else if (multies > 0 && descriptive == 0)
            return ExamType.MULTI_CHOICES;
        else
            return ExamType.DESCRIPTIVE;


    }
    @Named("convertAcceptanceLimit")
     Double convertAcceptanceLimit(String acceptanceLimit ) {
        try {
            return Double.valueOf(acceptanceLimit);
        }catch (Exception e){
            return 0D;
        }



    }

}
