package com.nicico.training.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.IQuestionProtocolService;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.QuestionProtocol;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TestQuestionDAO;
import com.nicico.training.repository.TestQuestionProtocolDAO;
import dto.exam.ImportedQuestionProtocol;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.exam.ExamAnswerDto;
import response.exam.ExamResultDto;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class QuestionProtocolService implements IQuestionProtocolService {

      private final TestQuestionProtocolDAO testQuestionProtocolDAO;
      private final ITestQuestionService testQuestionService;


    @Transactional
    @Override
    public  void saveQuestionProtocol(Long sourceExamId, List<ImportedQuestionProtocol> protocols) {
        List<QuestionProtocol> questionProtocols=findAllByExamId(sourceExamId);
        for (QuestionProtocol questionProtocol:questionProtocols){
            testQuestionProtocolDAO.delete(questionProtocol);
        }
        TestQuestion testQuestion=testQuestionService.findById(sourceExamId);

        for (ImportedQuestionProtocol protocol:protocols){
            QuestionProtocol questionProtocol=new QuestionProtocol();
            questionProtocol.setCorrectAnswerTitle(protocol.getCorrectAnswerTitle());
            questionProtocol.setExam(testQuestion);
            questionProtocol.setExamId(sourceExamId);
            questionProtocol.setQuestionId(protocol.getQuestion().getId());
            questionProtocol.setTime(protocol.getTime());
            questionProtocol.setQuestionMark( protocol.getMark().floatValue() );
            testQuestionProtocolDAO.save(questionProtocol);
         }
    }

    @Override
    public List<QuestionProtocol> findAllByExamId(Long id) {
        return testQuestionProtocolDAO.findAllByExamId(id);
    }
}
