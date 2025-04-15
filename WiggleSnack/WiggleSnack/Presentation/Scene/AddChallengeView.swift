//
//  AddChallengeView.swift
//  WiggleSnack
//
//  Created by 아우신얀 on 4/14/25.
//

import SwiftUI

struct AddChallengeView: View {
    @State private var title: String = ""
    @State private var memo: String = ""
    @State private var date: Date = Date()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    /// 카테고리 바텀시트를 보여주도록 하는 상태변수
    @State private var isActiveCategory: Bool = false
    /// datepicker을 보여주도록 하는 변수
    @State private var isActivePicker: Bool = false
    
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 56)
                titleComponent()
                
                Spacer().frame(height: 33)
                
                categoryComponent()
                
                Spacer().frame(height: 25)
                
                setDateComponent()
                
                Spacer().frame(height: 33)
                
                memoComponent()
                
                Spacer()
                
                CustomBottomBtn(action: {
                    
                }, label: "확인")
                .padding(.bottom, 34)
                
                
                
            }
            .padding(.horizontal, 20)
            .navigationTitle("도전 일기 추가하기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackBtn()
                            .padding(.leading, 5)
                            .contentShape(Rectangle())
                        
                    }.offset(x: -10)
                }
            }
            .sheet(isPresented: $isActiveCategory) {
                Spacer().frame(height: 56)
                
                CategoryListView()
                    .presentationDetents([.large, .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            }
            .sheet(isPresented: $isActivePicker) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .presentationDetents([.medium, .medium])
                    .datePickerStyle(.graphical)
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.horizontal, 20)
                    .presentationCornerRadius(20)
                
            }
        }
        
    }
    
    @ViewBuilder
    private func titleComponent() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            InquiryText(title: "목표", isRequired: true)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .foregroundColor(.gray01)
                    .cornerRadius(4)
                
                
                if title.isEmpty {
                    Text("청소하기, 하루 5분 명상하기...")
                        .font(.H5MediumFont())
                        .foregroundColor(.gray02)
                        .padding(.leading, 17)
                }
                
                TextField(text: $title, label: {
                    
                })
                .offset(x: 17)
                .onChange(of: title) { newValue in
                    if newValue.count > 23 {
                        title = String(newValue.prefix(23)) // 글자 수 제한
                    }
                }
                .font(.H5MediumFont())
                .foregroundColor(.gray05)
                
                
                
            }
            
        }
    }
    
    @ViewBuilder
    private func categoryComponent() -> some View {
        HStack {
            InquiryText(title: "카테고리", isRequired: true)
            
            Spacer()
            
            Button(action: {
                isActiveCategory = true
            }, label: {
                Text("카테고리를 선택해주세요")
                    .font(.H6MediumFont())
                    .foregroundColor(.gray03)
                
                
                Image("icon_arrow_front_small")
                    .resizable()
                    .frame(width: 27, height: 27)
            })
            .buttonStyle(.plain)
            
        }
    }
    
    @ViewBuilder
    private func setDateComponent() -> some View {
        VStack(spacing: 25) {
            HStack {
                InquiryText(title: "시작일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                }, label: {
                    
                    Text("")
                        .font(.H6MediumFont())
                        .foregroundColor(.gray03)
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
            
            HStack {
                InquiryText(title: "종료일", isRequired: true)
                
                Spacer()
                
                Button(action: {
                    isActivePicker = true
                }, label: {
                    Text("")
                        .font(.H6MediumFont())
                        .foregroundColor(.gray03)
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .frame(width: 27, height: 27)
                })
                .buttonStyle(.plain)
                
            }
        }
        
    }
    
    @ViewBuilder
    private func memoComponent() -> some View {
        VStack(alignment: .leading) {
            InquiryText(title: "다짐 및 도전 목표", isRequired: false)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.gray01)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                
                TextEditor(text: $memo)
                    .font(.H5MediumFont())
                    .padding(.horizontal, 10)
                    .zIndex(0)
                    .colorMultiply(Color(.gray01))
                    .cornerRadius(6)
                
                
                if memo.isEmpty {
                    Text("")
                        .font(.B1MediumFont())
                        .padding(.leading, 14)
                        .padding(.top, 16)
                        .foregroundColor(.gray02)
                        .cornerRadius(6)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .frame(maxWidth: .infinity, maxHeight: 150)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
    
    
}

#Preview {
    AddChallengeView()
}
