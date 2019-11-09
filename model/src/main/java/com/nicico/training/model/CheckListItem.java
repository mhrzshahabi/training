package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_check_list_item")
public class CheckListItem extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Check_List_Item_seq")
    @SequenceGenerator(name = "Check_List_Item_seq", sequenceName = "seq_Check_List_Item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_description")
    private String description;

    @Column(name = "b_enabled")
    private Boolean enableStatus;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_check_list_id", insertable = false, updatable = false)
    private CheckList checkList;

    @Column(name = "f_check_list_id")
    private Long CheckListId;


}
