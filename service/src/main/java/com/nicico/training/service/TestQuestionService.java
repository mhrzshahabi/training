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
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.TestQuestionDAO;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class TestQuestionService implements ITestQuestionService {

    private final ModelMapper modelMapper;
    private final TestQuestionDAO testQuestionDAO;
    private final ReportUtil reportUtil;
    private final ObjectMapper mapper;


    @Override
    public TestQuestionDTO.Info get(Long id) {
        return modelMapper.map(testQuestionDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound)), TestQuestionDTO.Info.class);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<TestQuestionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(testQuestionDAO, request, term -> modelMapper.map(term, TestQuestionDTO.Info.class));
    }

    @Transactional
    @Override
    public Set<QuestionBankDTO.Exam> getAllQuestionsByTestQuestionId(Long testQuestionId){
        final TestQuestion model = testQuestionDAO.findById(testQuestionId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound));
        Set<QuestionBank> result = new HashSet<>();
        model.getQuestionBankTestQuestionList().forEach(q -> result.add(q.getQuestionBank()));
        return modelMapper.map(result, new TypeToken<Set<QuestionBankDTO.Exam>>(){}.getType());
    }

    @Transactional
    @Override
    public void print (HttpServletResponse response, String type , String fileName, Long testQuestionId, String receiveParams) throws Exception {
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        TestQuestionDTO.Info model = get(testQuestionId);

        Set<QuestionBankDTO.Exam> testQuestionBanks = getAllQuestionsByTestQuestionId(testQuestionId);

        for(QuestionBankDTO.Exam q : testQuestionBanks){
            if(q.getQuestionType().getCode().equals("Descriptive")){
                q.setQuestion(q.getQuestion() + "\n\n\n\n");
            }
        }

        String data = mapper.writeValueAsString(testQuestionBanks);
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        params.put("class", model.getTclass().getTitleClass());
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }
}
