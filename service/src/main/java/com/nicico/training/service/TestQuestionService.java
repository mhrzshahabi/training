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
import com.nicico.training.mapper.QuestionBank.QuestionBankBeanMapper;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.QuestionBankDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TestQuestionDAO;
import dto.exam.EQuestionType;
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
import java.util.*;

@RequiredArgsConstructor
@Service
public class TestQuestionService implements ITestQuestionService {

    private final ObjectMapper mapper;
    private final TclassDAO tclassDAO;
    private final ReportUtil reportUtil;
    private final ModelMapper modelMapper;
    private final QuestionBankBeanMapper questionBankBeanMapper;
    private final TestQuestionDAO testQuestionDAO;
    private final QuestionBankDAO questionBankDAO;

    @Transactional
    @Override
    public TestQuestionDTO.fullInfo get(Long id) {
        TestQuestion model = testQuestionDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));
        return modelMapper.map(model, TestQuestionDTO.fullInfo.class);
    }

    @Override
    public TestQuestion getById(Long id) {
        return testQuestionDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<TestQuestionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(testQuestionDAO, request, term -> modelMapper.map(term, TestQuestionDTO.Info.class));
    }

    @Transactional
    @Override
    public Set<QuestionBankDTO.Exam> getAllQuestionsByTestQuestionId(Long testQuestionId) {
        final TestQuestion model = testQuestionDAO.findById(testQuestionId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));
        Set<QuestionBank> result = new HashSet<>();
        model.getQuestionBankTestQuestionList().forEach(q -> result.add(q.getQuestionBank()));
        return questionBankBeanMapper.toExamDtos(result);
    }

    @Transactional
    public Set<QuestionBankDTO.ElsExam> getAllQuestionsByTestQuestionIdForEls(Long testQuestionId) {
        final TestQuestion model = testQuestionDAO.findById(testQuestionId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));
        Set<QuestionBank> result = new HashSet<>();
        model.getQuestionBankTestQuestionList().forEach(q -> result.add(q.getQuestionBank()));
        return modelMapper.map(result, new TypeToken<Set<QuestionBankDTO.ElsExam>>() {
        }.getType());
    }

    @Transactional
    @Override
    public void delete(Long id) {
        testQuestionDAO.deleteById(id);
    }


    @Transactional
    @Override
    public TestQuestionDTO.Info create(TestQuestionDTO.Create request) {
        TestQuestion model = modelMapper.map(request, TestQuestion.class);
        model.setOnlineFinalExamStatus(false);

        if (testQuestionDAO.IsExist(model.getTclassId(), "FinalTest", 0L) == 0) {
            TestQuestion saved = testQuestionDAO.saveAndFlush(model);
            saved.setTclass(tclassDAO.findById(saved.getTclassId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound)));

            return modelMapper.map(saved, TestQuestionDTO.Info.class);
        } else {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

    }


    @Transactional
    @Override
    public TestQuestionDTO.Info update(Long id, TestQuestionDTO.Update request, HttpServletResponse response) {
        final TestQuestion dbModel = testQuestionDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));

        if (testQuestionDAO.IsExist(dbModel.getTclassId(), "FinalTest", id) == 0) {
            TestQuestion updating = new TestQuestion();
            modelMapper.map(dbModel, updating);
            modelMapper.map(request, updating);
            try {
                TestQuestion saved = testQuestionDAO.save(updating);

                saved.setTclass(tclassDAO.findById(saved.getTclassId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound)));
                testQuestionDAO.changeOnlineFinalExamStatus(updating.getId(), false);
                saved.setOnlineFinalExamStatus(false);
                return modelMapper.map(saved, TestQuestionDTO.Info.class);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        } else {
            try {
                response.sendError(405, null);
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

    }

    @Transactional
    @Override
    public void print(HttpServletResponse response, String type, String fileName, Long testQuestionId, String receiveParams) throws Exception {
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        TestQuestionDTO.fullInfo model = get(testQuestionId);

        Set<QuestionBankDTO.Exam> testQuestionBanks = getAllQuestionsByTestQuestionId(testQuestionId);
        List<QuestionBankDTO.Exam> finalQuestions = new ArrayList<>();

        for (QuestionBankDTO.Exam q : testQuestionBanks) {
            for (int i = 0; i <= q.getLines(); i++) {
                q.setQuestion(wrap_dir("rtl", q.getQuestion()) + "\n");
            }
            if (q.getQuestionType().getCode().equals("MultipleChoiceAnswer")) {
                if (q.getOption1() != null) {
                    q.setOption1(wrap_dir("rtl", q.getOption1()));
                }
                if (q.getOption2() != null) {
                    q.setOption2(wrap_dir("rtl", q.getOption2()));
                }
                if (q.getOption3() != null) {
                    q.setOption3(wrap_dir("rtl", q.getOption3()));
                }
                if (q.getOption4() != null) {
                    q.setOption4(wrap_dir("rtl", q.getOption4()));
                }
            }

            if (q.getQuestionType().getTitle().equals(EQuestionType.GROUPQUESTION.getValue())) {
                q.setQuestion(" با توجه  به سوال زیر به " + q.getChilds().size() + " سوال زیر را جواب دهید  " + "\n" + q.getQuestion());
                finalQuestions.add(q);
                for (QuestionBankDTO.Exam  z : q.getChilds()) {
                    for (int i = 0; i <= q.getLines(); i++) {
                        z.setQuestion(wrap_dir("rtl", z.getQuestion()) + "\n");
                    }
                    if (z.getQuestionType().getCode().equals("MultipleChoiceAnswer")) {
                        if (z.getOption1() != null) {
                            z.setOption1(wrap_dir("rtl", z.getOption1()));
                        }
                        if (z.getOption2() != null) {
                            z.setOption2(wrap_dir("rtl", z.getOption2()));
                        }
                        if (z.getOption3() != null) {
                            z.setOption3(wrap_dir("rtl", z.getOption3()));
                        }
                        if (z.getOption4() != null) {
                            z.setOption4(wrap_dir("rtl", z.getOption4()));
                        }
                    }
                    finalQuestions.add(z);

                }

            }else{
                finalQuestions.add(q);
            }
        }

        String data = mapper.writeValueAsString(finalQuestions);
        params.put("today", DateUtil.todayDate());
        params.put("course", model.getTclass().getTitleClass());
        params.put("class_code", model.getTclass().getCode());
        params.put("date", model.getDate() != null ? model.getDate() : null);
        params.put("time", model.getTime() != null ? model.getTime() : null);
        params.put("duration", model.getDuration() != null ? model.getDuration().toString() + " دقیقه" : null);
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    /**
     * to make an String RTL or LTR
     *
     * @param dir
     * @param str
     * @return changed String base of dir
     */
    public static String wrap_dir(String dir, String str) {
        if (dir == "rtl") return '\u202B' + str + '\u202C';
        else if (dir == "ltr") return '\u202A' + str + '\u202C';
        else return str;
    }

    @Override
    public void changeOnlineFinalExamStatus(Long examId, boolean state) {
        testQuestionDAO.changeOnlineFinalExamStatus(examId, state);
    }

    @Override
    public TestQuestion findById(Long sourceExamId) {
        return testQuestionDAO.findById(sourceExamId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TestQuestionNotFound));
    }

    @Override
    public TestQuestion findByTestQuestionTypeAndTclassId(String testQuestionType, Long classId) {
        return testQuestionDAO.findTestQuestionByTclassAndTestQuestionType(classId, testQuestionType);
    }

    @Transactional
    public void printElsPdf(HttpServletResponse response, String type, String fileName, Long testQuestionId,
                            String receiveParams, ExamResultDto exam) throws Exception {
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        TestQuestionDTO.fullInfo model = get(testQuestionId);

        Set<QuestionBankDTO.ElsExam> testQuestionBanks = getAllQuestionsByTestQuestionIdForEls(testQuestionId);

        for (QuestionBankDTO.ElsExam q : testQuestionBanks) {
            if (q.getQuestionType().getCode().equals("Descriptive")) {
                for (int i = 0; i <= q.getLines(); i++) {
                    q.setQuestion(q.getQuestion() + "\n");
                }
            }
            ExamAnswerDto answer;
            answer = exam.getAnswers().stream()
                    .filter(x -> x.getQuestion().trim().equals(q.getQuestion().trim()))
                    .findFirst()
                    .orElse(null);
            if (answer != null) {
                if (answer.getAnswer() != null)
                    q.setAnswer(answer.getAnswer().replace("\n", " "));
                else
                    q.setAnswer("پاسخ داده نشده" + "\n");


                String questionWithMark = q.getQuestion() +
                        " ( بارم : " + answer.getMark() + " ) ";
                q.setQuestion(questionWithMark);
            } else
                q.setAnswer("پاسخ داده نشده" + "\n");

            if (answer != null && answer.getExaminerAnswer() != null)
                q.setExaminerAnswer(answer.getExaminerAnswer());
            else
                q.setExaminerAnswer("پاسخ داده نشده" + "\n");


        }

        String data = mapper.writeValueAsString(testQuestionBanks);
        params.put("today", DateUtil.todayDate());
        params.put("course", model.getTclass().getTitleClass());
        params.put("class_code", model.getTclass().getCode());
        params.put("date", model.getDate() != null ? model.getDate() : null);
        params.put("time", model.getTime() != null ? model.getTime() : null);
        params.put("duration", model.getDuration() != null ? model.getDuration().toString() + " دقیقه" : null);
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    public long getPreTestId(long id) {
        return testQuestionDAO.findTestQuestionByTclassAndTestQuestionType(id, "PreTest").getId();
    }

    @Override
    public TestQuestion createPreTest(Long classId) {
        String testQuestionType = "PreTest";

        TestQuestion testQuestion = testQuestionDAO.findTestQuestionByTclassAndTestQuestionType(classId, testQuestionType);

        if (testQuestion == null) {
            testQuestion = new TestQuestion();
            testQuestion.setTestQuestionType(testQuestionType);
            testQuestion.setPreTestQuestion(true);
            testQuestion.setTclassId(classId);
            testQuestionDAO.save(testQuestion);
        } else {
            throw new TrainingException(TrainingException.ErrorType.conflict, null, "برای این کلاس، پیش آزمون وجود دارد");
        }

        return testQuestion;
    }

    public List<TestQuestion> getTeacherExamsNotSentToEls(String teacherNationalCode) {
        return testQuestionDAO.getTeacherExamsNotSentToEls(teacherNationalCode);
    }
}
